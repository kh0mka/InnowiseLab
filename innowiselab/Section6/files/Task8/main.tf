provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "private_subnet"
}

module "public_subnets" {
  source       = "./modules/public_subnets"
  subnet_count = var.public_subnet_count
}

module "private_subnets" {
  source       = "./modules/private_subnets"
  subnet_count = var.private_subnet_count
  providers    = { aws = aws.private_subnet }
}

module "public_subnet_security_group" {
  source = "./modules/security_group"

  vpc_id     = module.public_subnets.get_public_vpc_id
  depends_on = [module.public_subnets]

  tags_for_resource = { aws_wg = { "Name" = "SG for TGW public subnets" } }
}

module "private_subnet_security_group" {
  source = "./modules/security_group"

  vpc_id     = module.private_subnets.get_private_vpc_id
  depends_on = [module.private_subnets]

  tags_for_resource = { aws_wg = { "Name" = "SG for TGW private subnets" } }

  providers = {
    aws = aws.private_subnet
  }
}

module "instances" {
  source = "./modules/instance"

  public_instance_security_groups = module.public_subnet_security_group.sg_id
  public_instance_subnet_id       = module.public_subnets.get_public_subnet_ids[0]
  public_instance_key_name        = "khomenokkey"

  private_instance_security_groups = module.private_subnet_security_group.sg_id
  private_instance_subnet_id       = module.private_subnets.get_private_subnet_ids[0]

  providers = {
    aws.public_subnet  = aws
    aws.private_subnet = aws.private_subnet
  }
}

module "transit_gateway" {
  source = "./modules/transit_gateway"

  public_vpc_id         = module.public_subnets.get_public_vpc_id
  public_subnet_ids     = module.public_subnets.get_public_subnet_ids[0]
  public_route_table_id = module.public_subnets.get_public_route_table_id

  private_vpc_id         = module.private_subnets.get_private_vpc_id
  private_subnet_ids     = module.private_subnets.get_private_subnet_ids[0]
  private_route_table_id = module.private_subnets.get_private_route_table_id

  providers = {
    aws.public_subnet  = aws
    aws.private_subnet = aws.private_subnet
  }
}

