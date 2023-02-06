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
}

# Create AWS IAM user resource for each TJack, TJames, TMadhu and TDave
resource "aws_iam_user" "TJack" {
  name = "TJack"
}

resource "aws_iam_user" "TJames" {
  name = "TJames"
}

resource "aws_iam_user" "TMadhu" {
  name = "TMadhu"
}

resource "aws_iam_user" "TDave" {
  name = "TDave"
}