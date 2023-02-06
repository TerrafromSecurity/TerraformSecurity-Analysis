terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# AWS provider block in us east 1
provider "aws" {
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
  region     = "us-east-1"
}

# Create AWS IAM user resource for each TJack, TJames, TMadhu and TDave
resource "aws_iam_user" "tjack" {
  name = "TJack"
}

resource "aws_iam_user" "tjames" {
  name = "TJames"
}

resource "aws_iam_user" "tmadhu" {
  name = "TMadhu"
}

resource "aws_iam_user" "tdave" {
  name = "TDave"
}