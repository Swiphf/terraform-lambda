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

variable "s3_bucket" {
  type = string
}

variable "s3_key" {
  type = string
}

variable "runtime" {
  type = string
}

variable "stage" {
  type = string
}