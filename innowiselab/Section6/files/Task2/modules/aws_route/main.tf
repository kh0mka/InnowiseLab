# Creating route and attach to Route Table
resource "aws_route" "add_route" {
  count = length(var.list_of_destinations)

  route_table_id         = var.routetable_id
  gateway_id             = var.gateway_id_for_route
  destination_cidr_block = element(var.list_of_destinations, count.index)
}
