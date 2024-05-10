resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Policy for Lambda functions"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "rds-db:connect"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM role definition
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_execution_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [{
      "Effect"   : "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action"   : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Updating the bucket policy to grant permissions to the IAM role
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = data.aws_s3_bucket.code_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [{
      "Effect"    : "Allow",
      "Principal" : {
        "AWS": aws_iam_role.lambda_role.arn
      },
      "Action"    : "s3:GetObject",
      "Resource"  : "${data.aws_s3_bucket.code_bucket.arn}/*"
    }]
  })
}