# Private & Public VPC IDs output

output "private_vpc_id" {
  description = "Private VPC ID"
  value       = module.private_subnets.get_private_vpc_id
}

output "public_vpc_id" {
  description = "Public VPC ID"
  value       = module.public_subnets.get_public_vpc_id
}

# Private & Public IDs output

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.private_subnets.get_private_subnet_ids
}

output "public_subnet_id" {
  description = "List of public subnet IDs"
  value       = module.public_subnets.get_public_subnet_ids
}
