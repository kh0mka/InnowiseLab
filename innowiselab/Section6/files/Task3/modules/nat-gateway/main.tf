resource "aws_nat_gateway" "natgw" {
  count = var.subnet_count

  connectivity_type = "private"
  # allocation_id = element(aws_eip.natgw.*.id, count.index) // only for public ?
  subnet_id = element(var.subnet_ids, count.index)
  tags      = merge(var.tags, lookup(var.tags_for_resource, "aws_nat_gateway", {}))
}
