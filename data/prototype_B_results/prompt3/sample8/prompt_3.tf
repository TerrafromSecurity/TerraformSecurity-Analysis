provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "example_key" {
  description         = "Customer managed key for S3 bucket encryption"
  enable_key_rotation = true
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.example_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "example-logs-bucket"
    target_prefix = "example-bucket-logs/"
  }
}

resource "aws_s3_bucket_public_access_block" "example_bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}