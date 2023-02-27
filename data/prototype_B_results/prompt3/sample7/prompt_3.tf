terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"  # Change to your desired region
}

resource "aws_kms_key" "my_key" {
  description = "Customer-managed KMS key for S3 bucket encryption"
  
  # Enable key rotation
  enable_key_rotation = true
}

resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = "my-bucket-name"

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket-name"

  # Enable versioning
  versioning {
    enabled = true
  }

  # Add the following block to enable server-side encryption for the bucket using customer-managed keys
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.my_key.key_id
      }
    }
  }

  # Add the following block to enable access logging for the bucket
  logging {
    target_bucket = "my-logging-bucket" # Change to your desired logging bucket name
    target_prefix = "s3-logs/"
  }

  # Add the following block to enable object locking for the bucket
  object_lock_configuration {
    object_lock_enabled = "Enabled"
    rule {
      default_retention {
        mode = "COMPLIANCE"
        days = 30
      }
    }
  }

  # Add the following block to enable a bucket policy that restricts access to a specific IAM role
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "*",
      "Resource": [
        "${aws_s3_bucket.my_bucket.arn}",
        "${aws_s3_bucket.my_bucket.arn}/*"
      ],
      "Condition": {
        "StringNotEquals": {
          "aws:PrincipalArn": "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
        }
      }
    }
  ]
}
POLICY
}