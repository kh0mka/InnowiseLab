provider "aws" {
  region = "eu-north-1"
}

# Creating a VPC and a list of subnets in it
module "aws_vpc_with_subnets" {
  source = "./modules/aws_vpc_with_subnets"

  vpc_cidr             = "172.16.0.0/16"
  public_subnets_cidrs = ["172.16.0.0/24", "172.16.1.0/24", "172.16.2.0/24"]
  azs                  = ["eu-north-1a"]
  vpc_name             = "The main VPC of project"
}

# Creating internet gateway and attach his to VPC
module "aws_igw" {
  source = "./modules/aws_internet_gateway"

  vpc_id_for_igw = module.aws_vpc_with_subnets.main_vpc_id
  igw_name       = "Internet Gateway for main VPC"

  depends_on = [module.aws_vpc_with_subnets]
}

# Creating Route Table and attach her to VPC and IGW
module "aws_route_table" {
  source = "./modules/aws_route_table"

  route_table_cidr_block = "0.0.0.0/0"
  vpc_id_for_route_table = module.aws_vpc_with_subnets.main_vpc_id
  route_table_igw_id     = module.aws_igw.igw_id
  routetable_name        = "Route table for main VPC"

  depends_on = [module.aws_igw]
}

# Module for adding routes to Route Table, but it's not being used.
# Because the default routing path to the VPC network is specified
# in the route table. 

# module "add_routes" {
#   source = "./modules/aws_route"
#
#   routetable_id        = module.aws_route_table.route_table_id
#   gateway_id_for_route = module.aws_igw.igw_id
#   list_of_destinations = ["172.16.1.0/24", "172.16.2.0/24"]
#
#   depends_on = [module.aws_route_table]
# }

# Attach Route Table to subnets
module "attach_table_to_subnets" {
  source = "./modules/aws_route_table_association"

  route_table_to_attach = module.aws_route_table.route_table_id
  subnet_ids            = module.aws_vpc_with_subnets.getlist_of_subnet_ids

  # If you are using the "aws_route" module (add_routes), change the value of "depends_on" to module.add_routes
  depends_on = [module.aws_route_table]
}
