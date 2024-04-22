output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main_vpc.cidr_block
}

output "getlist_of_subnet_ids" {
  value = aws_subnet.creating_subnets[*].id
}
