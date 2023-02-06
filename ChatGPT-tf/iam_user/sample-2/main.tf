terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# AWS provider block in us east 1
provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-east-1"
}

# Create AWS IAM user resource for each TJack, TJames, TMadhu and TDave
resource "aws_iam_user" "name_0" {
  name = "TJack"
}

resource "aws_iam_user" "name_1" {
  name = "TJames"
}

resource "aws_iam_user" "name_2" {
  name = "TMadhu"
}

resource "aws_iam_user" "name_3" {
  name = "TDave"
}