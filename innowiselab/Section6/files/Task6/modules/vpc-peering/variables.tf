variable "vpc_id" {
  type = string
}

variable "peer_vpc_id" {
  type = string
}

variable "destination_cidr_block" {
  type    = list(string)
  default = ["172.17.0.0/16", "172.16.0.0/16"]
}

variable "route_table_id" {
  type = list(string)
}

variable "public_subnet_count" {
  type    = string
  default = "1"
}

variable "private_subnet_count" {
  type    = string
  default = "1"
}
