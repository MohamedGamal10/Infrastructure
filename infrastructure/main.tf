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
  asg-sg_name           = "asg-sg"
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
