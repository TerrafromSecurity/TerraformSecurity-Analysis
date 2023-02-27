terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-name"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-west-2:123456789012:key/abcdef01-2345-6789-0123-abcdef012345"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  logging {
    target_bucket = "example-logging-bucket"
    target_prefix = "s3-logs/"
  }
}

resource "aws_s3_bucket_public_access_block" "example_bucket_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}