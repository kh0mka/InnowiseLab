provider "aws" {
  region = "eu-north-1"
}

module "create-groups" {
  source      = "./modules/aws-iam-group/"
  group_names = ["Dev", "DevOps"]
}

module "create-policy-dev-group" {
  source             = "./modules/aws-iam-policy/"
  policy_name        = "DevEC2Policy"
  policy_description = "This policy allow to start & stop EC2 instances"
  attach_to_group    = ["Dev"]
  policy_permissions = var.policy_to_dev_group
  depends_on         = [module.create-groups]
}

module "create-policy-devops-group" {
  source             = "./modules/aws-iam-policy/"
  policy_name        = "DevOpsPolicy"
  policy_description = "Policy which give full access to EC2 instances"
  attach_to_group    = ["DevOps"]
  policy_permissions = ""
  set_policy_arn     = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  depends_on         = [module.create-groups]
}

module "create-users" {
  source        = "./modules/aws-iam-user/"
  list_of_users = var.users_to_create
  depends_on    = [module.create-policy-dev-group, module.create-policy-devops-group]
}

module "attach-users-to-dev-group" {
  source               = "./modules/aws-iam-user-group-membership/"
  listgroups_to_attach = ["Dev"]
  listusers_to_attach  = ["Givi", "Selin"]
  depends_on           = [module.create-users]
}

module "attach-users-to-devops-group" {
  source               = "./modules/aws-iam-user-group-membership/"
  listgroups_to_attach = ["DevOps"]
  listusers_to_attach  = ["Slava", "Rita"]
  depends_on           = [module.create-users]
}

module "attach-user-to-both-groups" {
  source               = "./modules/aws-iam-user-group-membership/"
  listgroups_to_attach = ["DevOps", "Dev"]
  listusers_to_attach  = ["Kirill"]
  depends_on           = [module.create-users]
}
