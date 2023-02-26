terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"

  public_access_block {
    block_public_acls    = true
    block_public_policy  = true
    ignore_public_acls   = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.example.arn
      }
    }
  }
  
  logging {
    target_bucket = "example-log-bucket"
    target_prefix = "logs/example-bucket/"
  }
}

resource "aws_kms_key" "example" {
  description = "KMS key for example-bucket"
  enable_key_rotation = true
}