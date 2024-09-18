output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "private_subnet_cidr" {
  value = [for subnet in aws_subnet.private : subnet.cidr_block]
}

output "public_subnet_cidr" {
  value = [for subnet in aws_subnet.public : subnet.cidr_block]
}