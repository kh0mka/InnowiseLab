# Generic variables

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "tags_for_resource" {
  description = "A nested map of tags to assign to specific resource types"
  type        = map(map(string))
  default = {
    aws_public_instance  = { "Name" = "Public Instance of TGW Peering" }
    aws_private_instance = { "Name" = "Private Instance of TGW Peering" }
  }
}

# Instance variables

variable "instance_count" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "public_instance_security_groups" {
  type    = string
  default = ""
}

variable "public_instance_subnet_id" {
  type    = string
  default = ""
}

variable "public_instance_key_name" {
  type    = string
  default = ""
}

variable "private_instance_security_groups" {
  type    = string
  default = ""
}

variable "private_instance_subnet_id" {
  type    = string
  default = ""
}
