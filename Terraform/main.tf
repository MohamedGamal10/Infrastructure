module "vpc" {
  source     = "./modules/vpc"
  vpc_cidr   = var.vpc_cidr
  vpc_name   = var.vpc_name
}

module "internet_gateway" {
  source  = "./modules/internet_gateway"
  vpc_id   = module.vpc.vpc_id  
  igw_name = var.igw_name
  vpc_name = module.vpc.vpc_name
}

module "nat_gateway" {
  source           = "./modules/nat_gateway"
  public_subnet_id = module.subnets.public_subnet_ids[0] 
  nat_name         = var.nat_name
  vpc_name = module.vpc.vpc_name
  depends_on = [module.internet_gateway]
}

module "subnets" {
  source              = "./modules/subnet"
  vpc_id              = module.vpc.vpc_id
  vpc_name            = module.vpc.vpc_name
  internet_gateway_id = module.internet_gateway.igw_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id

  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}
