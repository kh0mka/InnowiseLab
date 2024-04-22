# Generic variables

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "tags_for_resource" {
  description = "A nested map of tags to assign to specific resource types"
  type        = map(map(string))
  default = {
    aws_vpc = {
      "Name"        = "The main VPC"
      "Description" = "Primary VPC for task"
      "Section"     = "Terraform"
      "Task"        = "3"
    },
    aws_network_acl = {
      "Name"        = "The main NACL to filter traffic in subnets"
      "Description" = "Network Access Control List which allows 80,443 (inbound, outbound) on Public Subnet & inbound (49152 - 65535) sockets ports. All other - deny."
      "Section"     = "Terraform"
      "Task"        = "3"
    }
  }
}

# VPC variables

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/16"
}

# Public subnet variables

variable "public_cidr_block" {
  description = "The larger CIDR block to use for calculating individual public subnet CIDR blocks"
  type        = list(string)
  default     = ["172.16.0.0/24", "172.16.1.0/24", "172.16.2.0/24"]
}

variable "public_subnet_count" {
  description = "The number of public subnets to create"
  type        = string
  default     = "3"
}

variable "map_public_ip_on_launch" {
  description = "Assign a public IP address to instances launched into the public subnets"
  type        = string
  default     = true
}

# Private subnet variables

variable "private_cidr_block" {
  description = "The larger CIDR block to use for calculating individual private subnet CIDR blocks"
  type        = list(string)
  default     = ["172.16.3.0/24", "172.16.4.0/24", "172.16.5.0/24"]
}

variable "private_subnet_count" {
  description = "The number of private subnets to create"
  type        = string
  default     = "3"
}

variable "nacl_variables" {
  type = map(list(string))
  default = {
    rule_number = ["100", "110", "120", "130", "140"],
    egress      = ["false", "false", "true", "true", "false"],
    rule_action = ["allow", "allow", "allow", "allow", "allow"],
    protocol    = ["tcp", "tcp", "tcp", "tcp", "tcp"],
    from_port   = ["80", "443", "80", "443", "49152"],
    to_port     = ["80", "443", "80", "443", "65535"],
    cidr_block  = ["0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"]
  }
}
