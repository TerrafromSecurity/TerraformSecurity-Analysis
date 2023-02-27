provider "aws" {
  region = "us-west-2" # Replace with your desired region
}

resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket" # Replace with your desired bucket name

  tags = {
    Environment = "production"
  }

  # Add public access block to restrict public access to the bucket
  resource "aws_s3_bucket_public_access_block" "example_public_access_block" {
    bucket = aws_s3_bucket.example.id

    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = true
    restrict_public_buckets = true
  }

  # Add a bucket policy to restrict access to the bucket from a specific IP address
  resource "aws_s3_bucket_policy" "example_bucket_policy" {
    bucket = aws_s3_bucket.example.id

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "s3:*"
          Effect = "Deny"
          Principal = "*"
          Resource = "arn:aws:s3:::${aws_s3_bucket.example.id}/*"
          Condition = {
            IpAddress = {
              "aws:SourceIp": "203.0.113.0/24" # Replace with your desired IP address or CIDR block
            }
          }
        }
      ]
    })
  }

  # Add encryption configuration to encrypt objects stored in the bucket
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Add versioning configuration to enable versioning for objects stored in the bucket
  versioning {
    enabled = true
  }

  # Add a lifecycle configuration to expire objects in the bucket after a certain period of time
  lifecycle_rule {
    id      = "example-lifecycle-rule"
    status  = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }
  }

  # Add a replication configuration to replicate objects to a destination bucket in a different region
  replication_configuration {
    role = "arn:aws:iam::123456789012:role/replication-role"
    
    rules {
      id      = "example-replication-rule"
      status  = "Enabled"
      
      destination {
        bucket = "arn:aws:s3:::example-replication-bucket"
        storage_class = "STANDARD"
      }
      
      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }
      
      filter {
        prefix = "example/"
      }
    }
  }

  # Add bucket policy to deny public access
  resource "aws_s3_bucket_public_access_block" "example_public_access_block" {
    bucket = aws_s3_bucket.example.id

    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = true
    restrict_public_buckets = true
  }
  
  # Add a bucket policy to deny public access
  resource "aws_s3_bucket_public_access_block" "example_public_access_block" {
    bucket = aws_s3_bucket.example.id

    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = true
    restrict_public_buckets = true
  }
}