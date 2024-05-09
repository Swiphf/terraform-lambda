# General
aws_region = "eu-west-1"

# Lambda
function_name = "write_user_age_to_db"
role          = "aws_iam_role.lambda_role.arn"
handler       = "app.write_user_age_to_db"
runtime       = "python3.9"
filename      = "ido-backend-lambda-dev/lambda_function1/app.zip"
