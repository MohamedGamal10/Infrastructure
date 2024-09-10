resource "aws_subnet" "subnet" {
  for_each = var.subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = each.value.public
  availability_zone       = each.value.az

  tags = {
    "Name" = each.value.name
  }
}