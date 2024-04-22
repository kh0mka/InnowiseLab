# Attach Route Table to all subnets
resource "aws_route_table_association" "to_list_of_subnets" {
  count          = length(var.subnet_ids)
  route_table_id = var.route_table_to_attach
  subnet_id      = element(var.subnet_ids, count.index)
}
