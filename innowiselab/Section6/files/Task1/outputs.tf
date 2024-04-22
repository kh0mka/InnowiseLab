output "print_all_created_users" {
  value = module.create-users.print_created_users
}

output "print_arns_of_users" {
  value = module.create-users.print_arns_of_users
}

output "print_arns_of_groups" {
  value = module.create-groups.print_arns_of_groups
}