# Public Subnet variables

variable "subnet_cidr_block" {
  description = "The CIDR blocks for public subnets"
  type        = list(string)
  default     = ["172.16.1.0/24"]
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = string
}

variable "availability_zone" {
  description = "A name of availability zone"
  type        = string
  default     = "us-east-1a"
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

variable "map_public_ip_on_launch" {
  description = "Assign a public IP address to instances launched into these subnets"
  type        = string
  default     = true
}

# VPC varibales

variable "vpc_cidr_block" {
  type    = string
  default = "172.16.0.0/16"
}
