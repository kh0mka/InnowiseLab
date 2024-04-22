output "print_created_groups" {
  value = aws_iam_group.create-group[*].name
}

output "print_arns_of_groups" {
  value = zipmap(aws_iam_group.create-group[*].name, aws_iam_group.create-group[*].arn)
}
