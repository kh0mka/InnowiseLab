output "get_vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.vpc.id
}

output "get_vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "get_internet_gateway_id" {
  description = "The Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}
