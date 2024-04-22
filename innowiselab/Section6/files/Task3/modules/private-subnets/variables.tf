# Standard subnet variables

variable "vpc_id" {
  description = "The ID of the VPC to create the subnets in"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR blocks for private subnets"
  type        = list(string)
  default     = [""]
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = string
}

variable "availability_zone" {
  description = "A list of availability zones to create the subnets in"
  type        = string
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

# Private subnet variables

variable "nat_gateway_count" {
  description = "The number of NAT gateways to use for routing, must match subnet_count and nat_gateway_ids"
  default     = 0
}

variable "nat_gateway_ids" {
  description = "A list of NAT Gateway IDs to use for routing"
  default     = []
}
