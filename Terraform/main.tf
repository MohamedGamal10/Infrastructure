module "vpc" {
  source = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  vpc_name    = var.vpc_name
}

module "subnets" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id

  subnets = var.subnets
}