
resource "aws_lambda_function" "backend_lambda" {
  function_name    = "write_user_age_to_db"
  role             = aws_iam_role.lambda_role.arn
  handler          = "app.lambda_handler"
  runtime          = "python3.8"
  filename         = "${aws_s3_bucket_object.lambda_code.bucket}/${aws_s3_bucket_object.lambda_code.key}"
}

# resource "aws_api_gateway_rest_api" "backend_api" {
#   name = "BackendAPI"
# }

# resource "aws_api_gateway_resource" "backend_resource" {
#   rest_api_id = aws_api_gateway_rest_api.backend_api.id
#   parent_id   = aws_api_gateway_rest_api.backend_api.root_resource_id
#   path_part   = "backend"
# }

# resource "aws_api_gateway_method" "backend_method" {
#   rest_api_id   = aws_api_gateway_rest_api.backend_api.id
#   resource_id   = aws_api_gateway_resource.backend_resource.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "backend_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.backend_api.id
#   resource_id             = aws_api_gateway_resource.backend_resource.id
#   http_method             = aws_api_gateway_method.backend_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.backend_lambda.invoke_arn
# }

# resource "aws_api_gateway_deployment" "backend_deployment" {
#   depends_on = [aws_api_gateway_integration.backend_integration]
#   rest_api_id = aws_api_gateway_rest_api.backend_api.id
#   stage_name = "prod"
# }
