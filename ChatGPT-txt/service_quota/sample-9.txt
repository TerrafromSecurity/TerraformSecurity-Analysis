terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Provider Block: aws in us east 1 
provider "aws" {
  region = "us-east-1"
}

# create a service quota resource. Use quota code "L-F678F1CE" and service code "vpc". Use value 75
resource "aws_service_quota" "quota" {
  service_code = "vpc"
  quota_code   = "L-F678F1CE"
  value        = 75
}