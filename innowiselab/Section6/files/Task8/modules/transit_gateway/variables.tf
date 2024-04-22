# Generic variables for TGW

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "tags_for_resource" {
  description = "A nested map of tags to assign to specific resource types"
  type        = map(map(string))
  default = {
    tgw_vpc_attachment_public  = { "Name" = "Attachment of TGW with Public VPC (us-east-1)" }
    tgw_vpc_attachment_private = { "Name" = "Attachment of TGW with Private VPC (eu-west-1)" }
  }
}

# Public variables

variable "public_vpc_id" {
  type    = string
  default = ""
}

variable "public_subnet_ids" {
  type    = string
  default = ""
}

variable "public_destination_cidr_block" {
  type    = string
  default = "172.17.0.0/16"
}

variable "public_route_table_id" {
  type    = string
  default = ""
}

variable "public_route_destination_cidr_block" {
  type    = string
  default = "172.17.0.0/16"
}

# Private variables

variable "private_vpc_id" {
  type    = string
  default = ""
}

variable "private_subnet_ids" {
  type    = string
  default = ""
}

variable "private_destination_cidr_block" {
  type    = string
  default = "172.16.0.0/16"
}

variable "private_route_table_id" {
  type    = string
  default = ""
}

variable "private_route_destination_cidr_block" {
  type    = string
  default = "172.16.0.0/16"
}
