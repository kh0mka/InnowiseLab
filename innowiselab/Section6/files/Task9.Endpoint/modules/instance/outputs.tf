output "get_instance_ids" {
  value = aws_instance.createInstances.*.id
}
