
resource "aws_lambda_function" "backend_lambda" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  s3_bucket     = "ido-backend-lambda-dev"
  s3_key        = "lambda_function1/app.zip"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.backend_lambda.function_name}"
  retention_in_days = 30
}

resource "aws_api_gateway_rest_api" "backend_api" {
  name = "BackendAPI"
}

resource "aws_api_gateway_resource" "backend_resource" {
  rest_api_id = aws_api_gateway_rest_api.backend_api.id
  parent_id   = aws_api_gateway_rest_api.backend_api.root_resource_id
  path_part   = "backend"
}

resource "aws_api_gateway_method" "backend_method" {
  rest_api_id   = aws_api_gateway_rest_api.backend_api.id
  resource_id   = aws_api_gateway_resource.backend_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "backend_integration" {
  rest_api_id             = aws_api_gateway_rest_api.backend_api.id
  resource_id             = aws_api_gateway_resource.backend_resource.id
  http_method             = aws_api_gateway_method.backend_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.backend_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "backend_deployment" {
  depends_on  = [aws_api_gateway_integration.backend_integration]
  rest_api_id = aws_api_gateway_rest_api.backend_api.id
  stage_name  = "dev"
}
