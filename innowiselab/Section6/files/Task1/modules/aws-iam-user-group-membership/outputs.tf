output "print_attached_users" {
  value = aws_iam_user_group_membership.attach_user_to_group[*].user
}

output "print_attached_groups" {
  value = aws_iam_user_group_membership.attach_user_to_group[*].groups
}
