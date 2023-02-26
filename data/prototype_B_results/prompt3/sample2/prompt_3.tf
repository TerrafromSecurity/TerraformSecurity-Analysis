terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.79.0"
    }
  }
}

provider "aws" {
  region = "us-west-2" # Change this to your desired region
}

resource "aws_kms_key" "my_kms_key" {
  description             = "My customer managed KMS key"
  deletion_window_in_days = 30
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket" # Change this to your desired bucket name
  acl    = "private"

  tags = {
    Name = "My S3 Bucket"
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.my_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  logging {
    target_bucket = "my-logs-bucket" # Change this to your desired logs bucket name
    target_prefix = "my-bucket-logs/"
  }
}

resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}