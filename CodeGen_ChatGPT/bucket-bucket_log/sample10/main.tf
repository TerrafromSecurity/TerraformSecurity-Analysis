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

# create an s3 bucket, set bucket to "my-tf-log-bucket" and acl to "log-delivery-write"
# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create the S3 bucket
resource "aws_s3_bucket" "logs" {
  bucket = "my-tf-log-bucket"

  acl = "log-delivery-write"
}

# an s3 bucket, use bucket "my-tf-test-bucket" and acl private. Make a logging block, with target bucket id and target prefix "log/"
# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create the S3 bucket
resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-tf-test-bucket"

  acl = "private"

  logging {
    target_bucket = aws_s3_bucket.logs.id
    target_prefix = "log/"
  }
}

# Create the S3 bucket for logs
resource "aws_s3_bucket" "logs" {
  bucket = "my-tf-log-bucket"

  acl = "log-delivery-write"
}