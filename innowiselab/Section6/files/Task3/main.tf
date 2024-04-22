provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block = var.vpc_cidr_block

  tags              = var.tags
  tags_for_resource = var.tags_for_resource
}

module "public_subnets" {
  source = "./modules/public-subnets"

  vpc_id                  = module.vpc.get_vpc_id
  gateway_id              = module.vpc.get_internet_gateway_id
  map_public_ip_on_launch = var.map_public_ip_on_launch

  cidr_block        = var.public_cidr_block
  subnet_count      = var.public_subnet_count
  availability_zone = "eu-north-1a"

  tags              = var.tags
  tags_for_resource = var.tags_for_resource
}

module "private_subnets" {
  source = "./modules/private-subnets"

  vpc_id = module.vpc.get_vpc_id

  cidr_block        = var.private_cidr_block
  subnet_count      = var.private_subnet_count
  availability_zone = "eu-north-1b"

  tags              = var.tags
  tags_for_resource = var.tags_for_resource
}

#module "nat_gateways" {
#  source = "./modules/nat-gateway"
#
#  subnet_count = module.private_subnets.get_subnet_count
#  subnet_ids   = module.private_subnets.get_subnet_ids
#
#  tags              = var.tags
#  tags_for_resource = var.tags_for_resource
#}

module "nacl" {
  source = "./modules/nacl"

  vpc_id = module.vpc.get_vpc_id

  rules_count = 5

  network_acl_id = module.nacl.nacl_id

  rule_number = lookup(var.nacl_variables, "rule_number", []) // List(string)
  egress      = lookup(var.nacl_variables, "egress", [])      // List(bool)
  rule_action = lookup(var.nacl_variables, "rule_action", []) // List(string)
  protocol    = lookup(var.nacl_variables, "protocol", [])    // List(string)
  from_port   = lookup(var.nacl_variables, "from_port", [])   // List(string)
  to_port     = lookup(var.nacl_variables, "to_port", [])     // List(string)
  cidr_block  = lookup(var.nacl_variables, "cidr_block", [])  // List(string)

  subnetid_associate = concat(module.private_subnets.get_subnet_ids, module.public_subnets.get_subnet_ids)

  tags              = var.tags
  tags_for_resource = var.tags_for_resource
}
