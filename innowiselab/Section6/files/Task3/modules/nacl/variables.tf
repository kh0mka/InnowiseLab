variable "rules_count" {
  type    = string
  default = ""
}

variable "network_acl_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "rule_number" {
  type    = list(string)
  default = []
}

variable "protocol" {
  type    = list(string)
  default = []
}

variable "rule_action" {
  type    = list(string)
  default = []
}

variable "cidr_block" {
  type    = list(string)
  default = []
}

variable "from_port" {
  type    = list(string)
  default = []
}

variable "to_port" {
  type    = list(string)
  default = []
}

variable "egress" {
  type    = list(bool)
  default = []
}

variable "subnetid_associate" {
  type    = list(string)
  default = []
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "tags_for_resource" {
  description = "A nested map of tags to assign to specific resource types"
  type        = map(map(string))
  default     = {}
}
