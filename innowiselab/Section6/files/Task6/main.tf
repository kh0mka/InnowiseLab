provider "aws" {
  region = "eu-north-1"
}

module "public_subnets" {
  source       = "./modules/public-subnets"
  subnet_count = var.public_subnet_count
}

module "private_subnets" {
  source       = "./modules/private-subnets"
  subnet_count = var.private_subnet_count
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id = [module.public_subnets.get_public_vpc_id, module.private_subnets.get_private_vpc_id]
}

module "vpc_peering" {
  source = "./modules/vpc-peering"

  vpc_id         = module.public_subnets.get_public_vpc_id
  peer_vpc_id    = module.private_subnets.get_private_vpc_id
  route_table_id = [module.public_subnets.get_public_route_table_id, module.private_subnets.get_private_route_table_id]

  depends_on = [module.public_subnets, module.private_subnets]
}

module "instance" {
  source          = "./modules/instance"
  instance_count  = 2
  security_groups = module.security_group.sg_id
  subnet_id       = concat(module.public_subnets.get_public_subnet_ids, module.private_subnets.get_private_subnet_ids)
}
