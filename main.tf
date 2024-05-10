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

### IAM role module
module "iam_role" {
  source = "./modules/iam_role"
}

### Lambda module
module "lambda_funciton1" {
  source = "./modules/lambda_function1"

  function_name = var.function_name
  role_arn      = module.iam_role.iam_role_arn
  handler       = var.handler
  runtime       = var.runtime
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
}
