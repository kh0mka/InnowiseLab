variable "public_subnets_cidrs" {
  type    = list(string)
  default = []
}

variable "azs" {
  type    = list(string)
  default = []
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "vpc_name" {
  type    = string
  default = "Null (please set a name)"
}
