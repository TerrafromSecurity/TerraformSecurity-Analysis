provider "aws" {
  region = "us-west-2"
}

resource "aws_kms_key" "my_kms_key" {
  description = "My KMS Key"

  enable_key_rotation = true
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket"
  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.my_kms_key.arn
        sse_algorithm = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "my-bucket-logs"
    target_prefix = "s3-logs/"
  }
}

resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}