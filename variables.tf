variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "function_name" {
  type = string
}

variable "role" {
  type = string
}

variable "handler" {
  type = string
}

variable "filename" {
  type = string
}

variable "runtime" {
  type = string
}