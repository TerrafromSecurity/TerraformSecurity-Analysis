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
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-tf-log-bucket"
  acl    = "log-delivery-write"
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.log_bucket.id
  block_public_acls   = true
  block_public_policy = true
}

# an s3 bucket, use bucket "my-tf-test-bucket" and acl private. Make a logging block, with target bucket id and target prefix "log/"
resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-tf-test-bucket"
  acl    = "private"
}

# Enable logging for the bucket
resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.test_bucket.id

  target_bucket = aws_s3_bucket.test_bucket.id
  target_prefix = "log/"
}