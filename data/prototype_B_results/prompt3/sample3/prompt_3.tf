provider "aws" {
  region = "us-west-2"
}

resource "aws_kms_key" "example_key" {
  description = "Example KMS key"

  enable_key_rotation = true
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-example-bucket"
  acl    = "private"

  tags = {
    Environment = "test"
  }

  versioning {
    enabled = true
  }
  
  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.example_key.arn
      }
    }
  }

  logging {
    target_bucket = "my-logging-bucket"
    target_prefix = "my-logging-prefix/"
  }
}

resource "aws_s3_bucket_public_access_block" "example_bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}