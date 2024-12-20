# Default Subnet variables

variable "vpc_id" {
  description = "The ID of the VPC to create the subnets in"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR blocks for public subnets"
  type        = list(string)
  default     = [""]
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = string
}

variable "availability_zone" {
  description = "A name of availability zone"
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

# Public Subnet variables

variable "map_public_ip_on_launch" {
  description = "Assign a public IP address to instances launched into these subnets"
  type        = string
  default     = false
}

variable "gateway_id" {
  description = "The ID of the Internet Gateway to use for routing"
  type        = string
}
