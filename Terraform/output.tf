output "vpc_id" {
  value = module.vpc.vpc_id
}

output "internet_gateway_id" {
  value = module.internet_gateway.igw_id
}

output "nat_gateway_id" {
  value = module.nat_gateway.nat_gateway_id
}

output "asg_id" {
  value = module.asg.asg_id
}