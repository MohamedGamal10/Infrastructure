output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "public_subnet_cidr" {
  value = module.subnets.public_subnet_cidr
}

output "private_subnet_cidr" {
  value = module.subnets.private_subnet_cidr
}

output "asg_private_instance_ips" {
  value = module.asg.asg_instance_private_ips
}


output "bastion_public_ip" {
  value = module.bastion_host.bastion_public_ip
}

output "load_balancer_dns_name" {
  value = module.load_balancer.load_balancer_dns_name
}

output "load_balancer_arn" {
  value = module.load_balancer.alb_arn
}

output "target_group_arn" {
  value = module.load_balancer.target_group_arn
}
