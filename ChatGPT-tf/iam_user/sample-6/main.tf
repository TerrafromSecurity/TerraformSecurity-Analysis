terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# AWS provider block in us east 1
provider "aws" {
  region = "us-east-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
}

# Create AWS IAM user resource for each TJack, TJames, TMadhu and TDave
resource "aws_iam_user" "name_0" {
  name = "TJack"
}