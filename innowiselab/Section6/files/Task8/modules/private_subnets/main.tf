terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23"
    }
  }
}

resource "aws_vpc" "private_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_private_vpc",
    {
      "Name" = "Private VPC"
  }))
}

resource "aws_default_route_table" "vpc" {
  default_route_table_id = aws_vpc.private_vpc.default_route_table_id
  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_default_route_table",
    {
      "Name" = "Default Route Table in Private VPC"
  }))
}

resource "aws_subnet" "private_subnet" {
  count = var.subnet_count

  vpc_id            = aws_vpc.private_vpc.id
  cidr_block        = element(var.subnet_cidr_block, count.index)
  availability_zone = var.availability_zone

  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_private_subnet",
    {
      "Name" = "Private Subnet #${count.index + 1}"
  }))
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.private_vpc.id

  tags = merge(var.tags, lookup(var.tags_for_resource,
    "aws_private_subnet_route_table",
    {
      "Name" = "Route table of Private Subnets"
  }))
}

resource "aws_route_table_association" "default" {
  count = var.subnet_count

  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_subnet_route_table.id
}
