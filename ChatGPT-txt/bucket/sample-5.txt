terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Provider aws block with us east 1 region
provider "aws" {
  region = "us-east-1"
  access_key = "YOUR_AWS_ACCESS_KEY"
  secret_key = "YOUR_AWS_SECRET_KEY"
}

# Create S3 Bucket, set bucket to  "icecream"
resource "aws_s3_bucket" "icecream" {
  bucket = "icecream"
}