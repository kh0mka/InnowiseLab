resource "aws_iam_policy" "create-policy" {
  count       = var.policy_permissions != "" ? 1 : 0
  name        = var.policy_name
  description = var.policy_description
  policy      = var.policy_permissions
}

resource "aws_iam_policy_attachment" "attach-policy-to-group" {
  name       = var.policy_name
  policy_arn = var.policy_permissions != "" ? aws_iam_policy.create-policy[0].arn : var.set_policy_arn
  groups     = var.attach_to_group
}
