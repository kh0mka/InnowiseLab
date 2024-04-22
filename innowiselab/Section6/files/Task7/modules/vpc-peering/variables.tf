variable "vpc_id" {
  type    = string
  default = ""
}

variable "peer_vpc_id" {
  type    = string
  default = ""
}

# variable "destination_cidr_block" {
#   type    = list(string)
#   default = ["172.17.0.0/16", "172.16.0.0/16"]
# }

# variable "route_table_id" {
#   type = list(string)
# }

variable "destination_cidr_block" {
  type    = string
  default = ""
}

variable "route_table_id" {
  type    = string
  default = ""
}

variable "vpc_peering_connection_id" {
  type    = string
  default = ""
}

variable "public_subnet_count" {
  type    = string
  default = "1"
}

variable "private_subnet_count" {
  type    = string
  default = "1"
}

variable "peer_region" {
  type    = string
  default = ""
}

variable "count_vpc_peering" {
  type    = string
  default = "1"
}
