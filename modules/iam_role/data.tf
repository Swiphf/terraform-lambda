# Fetching information about the existing S3 bucket
data "aws_s3_bucket" "code_bucket" {
  bucket = "ido-backend-lambda-dev"
}