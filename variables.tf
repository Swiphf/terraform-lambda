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

variable "compatible_runtimes" {
  type = list(string)
}

variable "layer_name" {
  type = string
}

variable "layer_s3_bucket" {
  type = string
}

variable "layer_s3_key" {
  type = string
}
