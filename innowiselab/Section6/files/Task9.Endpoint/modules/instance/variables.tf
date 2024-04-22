# Generic variables

variable "names" {
  type    = map(string)
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "instance_tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}

variable "instance_tags_per_az" {
  description = "Additional tags for the instance where the primary key is the AZ"
  type        = map(map(string))
  default     = {}
}

# Instance variables

variable "instance_count" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = list(string)
  default = []
}

variable "azs" {
  type    = list(string)
  default = [""]
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_groups" {
  type    = list(string)
  default = []
}

variable "key_name" {
  type    = list(string)
  default = []
}
