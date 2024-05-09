terraform {
  backend "s3" {
    bucket = "ido-backend-lambda-dev"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}