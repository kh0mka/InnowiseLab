variable "route_table_cidr_block" {
  type    = string
  default = ""
}

variable "vpc_id_for_route_table" {
  type    = string
  default = ""
}

variable "route_table_igw_id" {
  type    = string
  default = ""
}

variable "routetable_name" {
  type    = string
  default = "Null (please set a name)"
}
