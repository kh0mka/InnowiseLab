resource "aws_iam_user" "create-users" {
  count = length(var.list_of_users)
  name  = element(var.list_of_users, count.index)
  path  = "/users/"
}
