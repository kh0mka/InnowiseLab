resource "aws_subnet" "private_subnet" {
  count = var.subnet_count

  vpc_id            = var.vpc_id
  cidr_block        = element(var.cidr_block, count.index)
  availability_zone = var.availability_zone

  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_private_subnet",
    {
      "Name"        = "Private Subnet #${count.index + 1}"
      "Description" = "Terraform Task 3"
  }))
}

resource "aws_route_table" "private_subnet_route_table" {
  # count = var.subnet_count
  vpc_id = var.vpc_id

  tags = merge(var.tags, lookup(var.tags_for_resource,
    "aws_private_subnet_route_table",
    {
      "Name"        = "Route table of Private Subnets"
      "Description" = "Route Table without IGW & NAT for Private Subnet"
      "Section"     = "Terraform"
      "Task"        = "3"
  }))
}

resource "aws_route_table_association" "default" {
  count = var.subnet_count

  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_subnet_route_table.id

  # For each subnet creating route table
  # route_table_id = element(aws_route_table.private_subnet_route_table.*.id, count.index)
}


# For NAT gateway
/* 
resource "aws_route" "nat_gateway" {
  count = var.nat_gateway_count

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = element(module.subnets.get_route_table_ids, count.index)
  nat_gateway_id         = element(var.nat_gateway_ids, count.index)
} */
