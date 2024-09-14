output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}

output "nat_eip" {
  value = aws_eip.nat_ip.public_ip
}
