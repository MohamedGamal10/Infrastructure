resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = var.subnet_public_ip
  availability_zone       = var.availability_zone

  tags = {
    "Name" = var.subnet_name
  }
}
