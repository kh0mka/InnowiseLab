terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23"
    }
  }
}

resource "aws_vpc_peering_connection" "VPCPeeringConnection" {
  count = var.count_vpc_peering

  vpc_id      = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  peer_region = var.peer_region

  tags = {
    Name = "PeeringConnectionBetweenVPCs"
  }
}

resource "aws_route" "add_routes" {
  route_table_id            = var.route_table_id
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = var.vpc_peering_connection_id
}
