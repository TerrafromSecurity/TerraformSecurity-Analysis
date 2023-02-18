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
# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket
resource "aws_s3_bucket" "cookie" {
  bucket = "cookie"
}

# Resource, aws s3 bucket object. Set key to index.html and use the s3 bucket id
# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket-name"
}

# Create an S3 bucket object
resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "index.html"
  source = "path/to/index.html"
}