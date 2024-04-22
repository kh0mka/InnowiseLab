# Private Subnet variables

variable "subnet_cidr_block" {
  description = "The CIDR blocks for private subnets"
  type        = list(string)
  default     = ["172.17.1.0/24"]
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = string
}

variable "availability_zone" {
  description = "A list of availability zones to create the subnets in"
  type        = string
  default     = "eu-north-1a"
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

# VPC variables

variable "vpc_cidr_block" {
  type    = string
  default = "172.17.0.0/16"
}
