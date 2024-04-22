variable "bucket" {
  type    = string
  default = ""
}

variable "key" {
  type    = list(string)
  default = []
}

variable "sourceTo" {
  type    = list(string)
  default = []
}

variable "content_type" {
  type    = list(string)
  default = []
}
