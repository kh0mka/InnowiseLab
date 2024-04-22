provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "private_subnet"
}

module "public_subnets" {
  source       = "./modules/public-subnets"
  subnet_count = var.public_subnet_count
}

module "private_subnets" {
  source       = "./modules/private-subnets"
  subnet_count = var.private_subnet_count
  providers    = { aws = aws.private_subnet }
}

module "public_subnet_security_group" {
  source = "./modules/security-group"

  vpc_id     = module.public_subnets.get_public_vpc_id
  depends_on = [module.public_subnets]
}

module "private_subnet_security_group" {
  source = "./modules/security-group"

  vpc_id     = module.private_subnets.get_private_vpc_id
  depends_on = [module.private_subnets]
  providers = {
    aws = aws.private_subnet
  }
}

module "vpc_peering" {
  source = "./modules/vpc-peering"

  vpc_id      = module.public_subnets.get_public_vpc_id
  peer_vpc_id = module.private_subnets.get_private_vpc_id
  peer_region = "eu-west-1"

  route_table_id            = module.public_subnets.get_public_route_table_id
  vpc_peering_connection_id = module.vpc_peering.get_vpc_peering_id[0]
  destination_cidr_block    = "172.17.0.0/16"

  depends_on = [module.public_subnet_security_group]
}

module "vpc_peering_route" {
  source            = "./modules/vpc-peering"
  count_vpc_peering = 0

  route_table_id            = module.private_subnets.get_private_route_table_id
  destination_cidr_block    = "172.16.0.0/16"
  vpc_peering_connection_id = module.vpc_peering.get_vpc_peering_id[0]

  providers = {
    aws = aws.private_subnet
  }

  depends_on = [module.private_subnet_security_group]
}

resource "aws_vpc_peering_connection_accepter" "peer_private" {
  provider                  = aws.private_subnet
  vpc_peering_connection_id = module.vpc_peering.get_vpc_peering_id[0]
  auto_accept               = true
}

module "public_instance" {
  source          = "./modules/instance"
  security_groups = module.public_subnet_security_group.sg_id
  subnet_id       = module.public_subnets.get_public_subnet_ids[0]
  key_name        = "khomenokkey"
  depends_on      = [module.vpc_peering]
}

module "private_instance" {
  source          = "./modules/instance"
  security_groups = module.private_subnet_security_group.sg_id
  subnet_id       = module.private_subnets.get_private_subnet_ids[0]
  providers = {
    aws = aws.private_subnet
  }
  depends_on = [module.vpc_peering]
}


