output "get_public_instance_ids" {
  value = aws_instance.public_instance.*.id
}

output "get_private_instance_ids" {
  value = aws_instance.private_instance.*.id
}
