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
    aws_web_instance = {
      "Name"        = "Instance of Web-Server"
      "Description" = "Created using the Instance module"
      "Section"     = "Terraform"
      "Task"        = "4"
    }
  }
}

# Instance variables

variable "instance_count" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type    = list(string)
  default = []
}

variable "userdata_file" {
  type    = string
  default = ""
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = [""]
}

variable "iam_instance_profile" {
  type    = string
  default = ""
}
