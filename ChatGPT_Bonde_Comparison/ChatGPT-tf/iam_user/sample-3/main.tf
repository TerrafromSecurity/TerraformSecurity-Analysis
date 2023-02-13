terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# AWS provider block in us east 1
provider "aws" {
  access_key = "your-aws-access-key"
  secret_key = "your-aws-secret-key"
  region     = "us-east-1"
}

# Create AWS IAM user resource for each TJack, TJames, TMadhu and TDave
# Create an IAM user for TJack
resource "aws_iam_user" "name_0" {
  name = "TJack"
}

# Create an IAM user for TJames
resource "aws_iam_user" "name_1" {
  name = "TJames"
}

# Create an IAM user for TMadhu
resource "aws_iam_user" "name_2" {
  name = "TMadhu"
}

# Create an IAM user for TDave
resource "aws_iam_user" "name_3" {
  name = "TDave"
}