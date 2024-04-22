variable "policy_name" {
  type    = string
  default = ""
}

variable "policy_description" {
  type    = string
  default = ""
}

variable "policy_permissions" {
  default = ""
}

variable "attach_to_group" {
  type    = list(string)
  default = []
}

variable "set_policy_arn" {
  type    = string
  default = ""
}
