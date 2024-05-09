terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

### Lambda module 
module "lambda_funciton1" {
  source = "./modules/lambda_function1"

  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  runtime       = var.runtime
  filename      = var.filename
}
