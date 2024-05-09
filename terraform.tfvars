# General
aws_region = "eu-west-1"

# Lambda
function_name = ".."
role             = "aws_iam_role.lambda_role.arn"
handler          = "app.lambda_handler"
runtime          = "python3.9"
filename         = "${aws_s3_bucket_object.lambda_code.bucket}/${aws_s3_bucket_object.lambda_code.key}"