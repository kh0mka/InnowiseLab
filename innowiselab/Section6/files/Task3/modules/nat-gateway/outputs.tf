output "get_nat_gateway_count" {
  description = "The number of gateways"
  value       = var.subnet_count
}

output "get_nat_gateway_ids" {
  description = "List of gateway IDs"
  value       = aws_nat_gateway.natgw.*.id
}

#output "get_nat_gateway_public_ips" {
#  description = "List of public IPs belonging to the Nat Gateways"
#  value       = aws_eip.natgw.*.public_ip
#}
