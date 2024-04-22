output "get_subnet_count" {
  description = "The number of subnets"
  value       = var.subnet_count
}

output "get_public_subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.public_subnet.*.id
}

output "get_public_vpc_id" {
  value = aws_vpc.public_vpc.id
}

output "get_public_route_table_id" {
  value = aws_route_table.public_subnet_route_table.id
}
