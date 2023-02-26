terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "<insert version here>"
    }
  }
}

provider "aws" {
  region = "<insert region here>"
  access_key = "<insert access key here>"
  secret_key = "<insert secret key here>"
}

resource "aws_kms_key" "example_kms_key" {
  description = "Example KMS key"

  enable_key_rotation = true
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "<insert bucket name here>"
  acl = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.example_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  logging {
    target_bucket = "<insert target bucket name here>"
    target_prefix = "example-bucket-logs/"
  }
}

resource "aws_s3_bucket_public_access_block" "example_bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}