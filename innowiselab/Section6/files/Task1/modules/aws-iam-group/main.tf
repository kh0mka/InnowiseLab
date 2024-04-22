resource "aws_iam_group" "create-group" {
  count = length(var.group_names)
  name  = element(var.group_names, count.index)
  path  = "/groups/"
}
