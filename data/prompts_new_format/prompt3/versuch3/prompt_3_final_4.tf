terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.24.0"
    }
  }
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  
  acl    = "private"
  public_access_block_config {
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "alias/aws/s3"
        sse_algorithm = "aws:kms"
      }
    }
  }
  logging {
    target_bucket = "example-bucket-logs"
    target_prefix = "example-bucket-logs/"
  }
}