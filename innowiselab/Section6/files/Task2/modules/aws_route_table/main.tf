# Creating Route Table
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id_for_route_table

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = var.route_table_igw_id
  }

  tags = {
    Name = var.routetable_name
  }
}
