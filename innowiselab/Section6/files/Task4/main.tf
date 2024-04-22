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

module "sg" {
  vpc_id = module.vpc.get_vpc_id

  source = "./modules/security-group"

  dynamic_ingress = ["22", "80", "443"]
}

module "instance" {
  source = "./modules/instance"

  instance_count         = 1
  instance_type          = "t3.micro"
  subnet_id              = module.public_subnets.get_subnet_ids
  vpc_security_group_ids = module.sg.sg_id

  userdata_file = filebase64("./user_data/web/user_data.sh")
}
