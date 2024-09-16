output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_name" {
  value = var.vpc_name
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

