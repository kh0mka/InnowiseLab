terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.public_subnet,
        aws.private_subnet
      ]
    }
  }
}

data "aws_region" "peering" {
  provider = aws.private_subnet
}

# Get default route table ID of TGW (Public Subnet & Private Subnet)

data "aws_ec2_transit_gateway_route_table" "get_public" {
  provider = aws.public_subnet

  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = ["${aws_ec2_transit_gateway.public_tgw.id}"]
  }
}

data "aws_ec2_transit_gateway_route_table" "get_private" {
  provider = aws.private_subnet

  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = ["${aws_ec2_transit_gateway.private_tgw.id}"]
  }
}

##################################################################

# Create TGW for public subnet (us-east-1) & private private subnet (eu-west-1)

resource "aws_ec2_transit_gateway" "public_tgw" {
  provider                       = aws.public_subnet
  description                    = "Public Transit Gateway"
  auto_accept_shared_attachments = "enable"
}

resource "aws_ec2_transit_gateway" "private_tgw" {
  provider                       = aws.private_subnet
  description                    = "Private Transit Gateway"
  auto_accept_shared_attachments = "enable"
}

##################################################################

# Create VPC attachment (Public & Private subnets)

resource "aws_ec2_transit_gateway_vpc_attachment" "public" {
  provider   = aws.public_subnet
  vpc_id     = var.public_vpc_id
  subnet_ids = [var.public_subnet_ids]

  transit_gateway_id = aws_ec2_transit_gateway.public_tgw.id

  tags = merge(var.tags, lookup(var.tags_for_resource, "tgw_vpc_attachment_public", {}))
}

resource "aws_ec2_transit_gateway_vpc_attachment" "private" {
  provider   = aws.private_subnet
  vpc_id     = var.private_vpc_id
  subnet_ids = [var.private_subnet_ids]

  transit_gateway_id = aws_ec2_transit_gateway.private_tgw.id

  tags = merge(var.tags, lookup(var.tags_for_resource, "tgw_vpc_attachment_private", {}))
}

# Create peering attachment between Public --> Private Subnets

resource "aws_ec2_transit_gateway_peering_attachment" "peering_private" {
  provider = aws.public_subnet

  peer_region             = data.aws_region.peering.name
  peer_transit_gateway_id = aws_ec2_transit_gateway.private_tgw.id
  transit_gateway_id      = aws_ec2_transit_gateway.public_tgw.id

  tags = {
    Name = "TGW Peering Requestor"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "accept_peering" {
  provider = aws.private_subnet

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.peering_private.id
  tags = {
    Name = "TGW Peering Acceptor"
    Side = "Acceptor"
  }
}

##################################################################

##################################################################

# Create routes to TGW (Public & Private subnets)

resource "aws_ec2_transit_gateway_route" "publicRoute" {
  provider = aws.public_subnet

  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.get_public.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.peering_private.id
  destination_cidr_block         = var.public_destination_cidr_block // 172.17.0.0/16 go to TGW_attachment (peering)

  blackhole = false
}

resource "aws_ec2_transit_gateway_route" "privateRoute" {
  provider = aws.private_subnet

  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.get_private.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.peering_private.id
  destination_cidr_block         = var.private_destination_cidr_block // 172.16.0.0/16 go to TGW_attachment (peering)

  blackhole = false
}

##################################################################

# Adding routes to the transit gateway in subnet routing tables

resource "aws_route" "publicAddRouteToTGW" {
  provider = aws.public_subnet

  route_table_id         = var.public_route_table_id
  destination_cidr_block = var.public_route_destination_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.public_tgw.id
}

resource "aws_route" "privateAddRouteToTGW" {
  provider = aws.private_subnet

  route_table_id         = var.private_route_table_id
  destination_cidr_block = var.private_route_destination_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.private_tgw.id
}

##################################################################
