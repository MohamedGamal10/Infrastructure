resource "aws_eip" "nat_ip" {
  tags = {
    "Name" = "NAT_EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = var.public_subnet_id

  tags = {
    "Name" = "${var.vpc_name}-${var.nat_name}"
  }
}
