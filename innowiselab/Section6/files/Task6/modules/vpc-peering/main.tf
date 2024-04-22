resource "aws_vpc_peering_connection" "VPCPeeringConnection" {

  vpc_id      = var.vpc_id      // module.public_subnets.get_public_vpc_id
  peer_vpc_id = var.peer_vpc_id // module.private_subnets.get_private_vpc_id
  auto_accept = true

  tags = {
    Name = "PeeringConnectionBetweenVPCs"
  }
}

resource "aws_route" "add_routes" {
  count = (var.public_subnet_count + var.private_subnet_count)

  route_table_id            = element(var.route_table_id, count.index) // aws_route_table.private_subnet_route_table.id
  destination_cidr_block    = element(var.destination_cidr_block, count.index)
  vpc_peering_connection_id = aws_vpc_peering_connection.VPCPeeringConnection.id
}
