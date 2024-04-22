resource "aws_iam_user_group_membership" "attach_user_to_group" {
  count = length(var.listusers_to_attach)

  user   = element(var.listusers_to_attach, count.index)
  groups = var.listgroups_to_attach
}
