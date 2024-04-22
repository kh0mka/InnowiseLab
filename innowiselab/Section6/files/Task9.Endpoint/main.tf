provider "aws" {
  region = "eu-north-1"
}

module "vpc" {

  source = "./modules/vpc"

  cidr = "172.16.0.0/16"

  azs                     = ["eu-north-1a"]
  public_subnets          = ["172.16.1.0/24", "172.16.2.0/24"]
  map_public_ip_on_launch = true

  public_subnet_names     = ["[${module.vpc.vpc_id}] Public Subnet #1", "[${module.vpc.vpc_id}] Public Subnet #2"]
  public_route_table_tags = { "Name" = "Route table of public subnet" }

}

module "secondVpc" {

  source = "./modules/vpc"

  cidr = "172.17.0.0/16"

  azs                     = ["eu-north-1a"]
  public_subnets          = ["172.17.1.0/24", "172.17.2.0/24"]
  map_public_ip_on_launch = true

  public_subnet_names     = ["[${module.secondVpc.vpc_id}] Public Subnet #1", "[${module.secondVpc.vpc_id}] Public Subnet #2"]
  public_route_table_tags = { "Name" = "Route table of public subnet" }

}

module "vpc_sg" {

  source = "./modules/sg"

  name        = "[${module.vpc.vpc_id}] VPC SG"
  description = "Open traffic from all IPv4"
  vpc_id      = module.vpc.default_vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

}

module "secondVpc_sg" {

  source = "./modules/sg"

  name        = "[${module.secondVpc.vpc_id}] Second VPC SG"
  description = "Open traffic from all IPv4"
  vpc_id      = module.vpc.default_vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

}

module "createInstances" {

  source = "./modules/instance"

  instance_count = 2
  instance_type  = ["t3.micro"]

  key_name        = ["khomenokkey"]
  subnet_ids      = [module.vpc.public_subnets[0], module.secondVpc.public_subnets[0]]
  security_groups = [module.vpc_sg.security_group_id, module.secondVpc_sg.security_group_id]

}


# Not implemented further, the task is empty.
# The VPC Endpoint Gateway Service consists of: VPC Endpoint Gateway (for S3 & DynamoDB mapping), 
# and VPC Endpoint Interface, - for mapping other services.
# Implemented with Route Table and destination on endpoint gateway/interface
