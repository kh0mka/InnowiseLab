terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23"
    }
  }
}

resource "aws_vpc" "public_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_public_vpc",
    {
      "Name" = "Public VPC"
  }))
}

resource "aws_default_route_table" "vpc" {
  default_route_table_id = aws_vpc.public_vpc.default_route_table_id
  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_default_route_table",
    {
      "Name" = "Default Route Table in Public VPC"
  }))
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.public_vpc.id
  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_internet_gateway",
    {
      "Name" = "Internet Gateway"
  }))
}

resource "aws_subnet" "public_subnet" {
  count = var.subnet_count

  vpc_id                  = aws_vpc.public_vpc.id
  cidr_block              = element(var.subnet_cidr_block, count.index)
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_public_subnet",
    {
      "Name" = "Public Subnet #${count.index + 1}"
  }))
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.public_vpc.id

  tags = merge(var.tags, lookup(var.tags_for_resource,
    "aws_public_subnet_route_table",
    {
      "Name" = "Route table of Public Subnets"
  }))
}

resource "aws_route" "internet_gateway" {
  count = var.subnet_count

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = element(aws_route_table.public_subnet_route_table.*.id, count.index)
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "default" {
  count = var.subnet_count

  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_subnet_route_table.id
}
