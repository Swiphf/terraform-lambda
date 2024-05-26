# General
aws_region = "eu-west-1"

# Lambda
function_name = "write_user_age_to_db"
role          = "aws_iam_role.lambda_role.arn"
handler       = "app.lambda_handler"
runtime       = "python3.9"
s3_bucket     = "ido-backend-lambda-dev"
s3_key        = "lambda_function1/app.zip"
stage         = "dev"

# Layer
compatible_runtimes = ["python3.8", "python3.9", "python3.10", "python3.11", "python3.12"]
layer_name          = "python-layer"
layer_s3_bucket     = "ido-lambda-layers-dev"
layer_s3_key        = "python-layers/lambda-layer.zip"
