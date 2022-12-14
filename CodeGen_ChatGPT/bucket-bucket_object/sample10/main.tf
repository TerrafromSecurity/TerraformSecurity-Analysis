terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Provider Block with region us-east-1
provider "aws" {
  region = "us-east-1"
}

# Create S3 Bucket Resource. Set bucket to cookie
resource "aws_s3_bucket" "my_bucket" {
  bucket = "cookie"
}

# Resource, aws s3 bucket object. Set key to index.html and use the s3 bucket id
resource "aws_s3_bucket_object" "my_object" {
  bucket = aws_s3_bucket.cookie.id
  key    = "index.html"
}