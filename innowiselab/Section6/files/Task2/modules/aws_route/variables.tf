variable "routetable_id" {
  type    = string
  default = ""
}

variable "gateway_id_for_route" {
  type    = string
  default = ""
}

variable "list_of_destinations" {
  type = list(string)
}
