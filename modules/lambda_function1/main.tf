resource "aws_lambda_function" "backend_lambda" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  s3_bucket     = "ido-backend-lambda-dev"
  s3_key        = "lambda_function1/app.zip"

  environment {
    variables = {
      DB_NAME   = "your_db_name"
      DB_HOST   = "your_db_host"
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.backend_lambda.function_name}"
  retention_in_days = 3
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

resource "aws_api_gateway_method_settings" "api_gateway_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.backend_api.id
  stage_name  = var.stage
  method_path = "*/*"
  settings {
    logging_level      = "INFO"
    data_trace_enabled = true
    metrics_enabled    = true
  }

  depends_on = [ aws_api_gateway_rest_api.backend_api, aws_api_gateway_method.backend_method ]
}

resource "aws_api_gateway_integration" "backend_integration" {
  rest_api_id             = aws_api_gateway_rest_api.backend_api.id
  resource_id             = aws_api_gateway_resource.backend_resource.id
  http_method             = aws_api_gateway_method.backend_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.backend_lambda.invoke_arn

  credentials = aws_iam_role.main.arn
}

resource "aws_api_gateway_deployment" "backend_deployment" {
  depends_on  = [aws_api_gateway_integration.backend_integration]
  rest_api_id = aws_api_gateway_rest_api.backend_api.id
  stage_name  = var.stage
}

# Allow API Gateway to push logs to CloudWatch
resource "aws_api_gateway_account" "main" {
  cloudwatch_role_arn = aws_iam_role.main.arn
}

resource "aws_iam_role" "main" {
  name = "apiGatewayLogsRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_invoke_policy" {
  name        = "lambda-invoke-policy"
  description = "Policy to allow API Gateway to invoke Lambda functions"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "lambda:InvokeFunction",
        "Resource": aws_lambda_function.backend_lambda.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role_policy_attachment" "lambda_invoke_policy_attachment" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.lambda_invoke_policy.arn
}