terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-name"
  acl    = "private"

  # block public access
  block_public_acls = true
  block_public_policy = true

  # enable versioning
  versioning {
    enabled = true
  }

  # use customer managed keys for encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  
  logging {
    target_bucket = "example-bucket-logs"
    target_prefix = "example-bucket-logs/"
  }
}

resource "aws_kms_key" "example_key" {
  description = "Example customer managed key"
  enable_key_rotation = true
}