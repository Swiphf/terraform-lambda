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
module "lambda_funciton" {
  source = "./modules/lambda_function"

  aws_region                = var.aws_region
  function_name             = var.function_name
  role_arn                  = data.aws_iam_role.lambda_role.arn
  handler                   = var.handler
  runtime                   = var.runtime
  s3_bucket                 = var.s3_bucket
  s3_key                    = var.s3_key
  stage                     = var.stage
  layer_name                = var.layer_name
  layer_s3_key              = var.layer_s3_key
  layer_compatible_runtimes = var.compatible_runtimes
  layer_s3_bucket           = var.layer_s3_bucket
}
