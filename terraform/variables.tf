variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "container_name" {
  type    = string
  default = "tessian"
}

variable "container_port" {
  type    = number
  default = 80
}