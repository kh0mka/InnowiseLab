output "get_subnet_count" {
  description = "The number of subnets"
  value       = var.subnet_count
}

output "get_private_subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.private_subnet.*.id
}

output "get_private_vpc_id" {
  value = aws_vpc.private_vpc.id
}

output "get_private_route_table_id" {
  description = "List of route table IDs"
  value       = aws_route_table.private_subnet_route_table.id
}
