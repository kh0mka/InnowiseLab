output "instance_ids" {
  value = aws_instance.instance_of_web_server.*.id
}
