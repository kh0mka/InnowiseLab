output "print_created_users" {
  value = aws_iam_user.create-users[*].name
}

output "print_arns_of_users" {
  value = zipmap(aws_iam_user.create-users[*].name, aws_iam_user.create-users[*].arn)
}
