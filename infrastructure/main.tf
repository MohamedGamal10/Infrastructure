module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

module "internet_gateway" {
  source   = "./modules/internet_gateway"
  vpc_id   = module.vpc.vpc_id
  igw_name = var.igw_name
  vpc_name = module.vpc.vpc_name
}

module "nat_gateway" {
  source           = "./modules/nat_gateway"
  public_subnet_id = module.subnets.public_subnet_ids[0]
  nat_name         = var.nat_name
  vpc_name         = module.vpc.vpc_name
  depends_on       = [module.internet_gateway]
}

module "subnets" {
  source              = "./modules/subnet"
  vpc_id              = module.vpc.vpc_id
  vpc_name            = module.vpc.vpc_name
  internet_gateway_id = module.internet_gateway.igw_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "asg" {
  source                = "./modules/autoscalinggroups"
  asg_sg_name           = "asg-sg"
  asg_name              = "asg"
  vpc_id                = module.vpc.vpc_id
  vpc_name              = module.vpc.vpc_name
  vpc_cidr              = var.vpc_cidr
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  ebs_volume_size       = var.ebs_volume_size
  subnet_ids            = module.subnets.private_subnet_ids
  ebs_volume_type       = var.ebs_volume_type
  key_pair_name         = var.asg_key_pair_name
  instance_profile_name = var.instance_profile_name
  instance_role_name    = var.instance_role_name
  desired_capacity      = var.desired_capacity
  max_size              = var.max_size
  min_size              = var.min_size
}

module "bastion_host" {
  source               = "./modules/bastion_host"
  bastion_name         = "bastion"
  basion_instance_type = var.basion_instance_type
  vpc_id               = module.vpc.vpc_id
  vpc_name             = module.vpc.vpc_name
  basion_volume_size   = var.basion_volume_size
  basion_volume_type   = var.basion_volume_type
  public_subnet_id     = module.subnets.public_subnet_ids[1]
  basion_ami_id        = var.basion_ami_id
  basion_key_pair_name = var.basion_key_pair_name
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    bastion_public_ip = module.bastion_host.bastion_public_ip
    private_ips       = module.asg.asg_instance_private_ips
    bastion_key_path  = module.bastion_host.bastion_private_key_path
    asg_key_path      = module.asg.asg_private_key_path
  })
  filename = "${path.module}/../playbooks/inventory.ini"
}

resource "null_resource" "fix_key_permissions" {
  depends_on = [module.bastion_host, module.asg]

  provisioner "local-exec" {
    command = <<-EOT
      chmod 400 ${module.bastion_host.bastion_private_key_path}
      chmod 400 ${module.asg.asg_private_key_path}
    EOT
  }
}


resource "null_resource" "run_ansible" {
  depends_on = [module.asg, module.bastion_host, local_file.ansible_inventory, null_resource.fix_key_permissions]

  provisioner "local-exec" {
    command = <<-EOT
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${module.bastion_host.bastion_private_key_path} ${module.bastion_host.bastion_private_key_path} ${path.module}/modules/autoscalinggroups/keys/${var.asg_key_pair_name}.pem ${path.module}/../playbooks/inventory.ini ${path.module}/../playbooks/asg-playbook.yml ubuntu@${module.bastion_host.bastion_public_ip}:~
      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${module.bastion_host.bastion_private_key_path} ubuntu@${module.bastion_host.bastion_public_ip} "
        chmod 400 ~/${basename(module.bastion_host.bastion_private_key_path)}
        chmod 400 ~/${var.asg_key_pair_name}.pem
        sudo apt update
        sudo apt install -y ansible
        sleep 5
        ansible-playbook -i inventory.ini asg-playbook.yml --private-key=private-asg-key-pair.pem --ssh-common-args='-o StrictHostKeyChecking=no'
        rm -f *.pem
        "
    EOT
  }
}

module "load_balancer" {
  source                     = "./modules/load_balancer"
  lb_name                    = "lb"
  vpc_id                     = module.vpc.vpc_id
  vpc_name                   = module.vpc.vpc_name
  public_subnet_ids          = module.subnets.public_subnet_ids[*]
  asg_name                   = module.asg.asg_name
  enable_deletion_protection = false
  idle_timeout               = 60
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = module.asg.asg_name
  lb_target_group_arn    = module.load_balancer.target_group_arn
}