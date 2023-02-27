provider "aws" {
  region = "us-west-2"   # Replace with your desired AWS region
}

# Create a KMS key for S3 encryption
resource "aws_kms_key" "example" {
  description = "Example KMS key"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"   # Replace with your desired bucket name

  acl    = "private"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  # Public access block configuration
  resource "aws_s3_bucket_public_access_block" "example" {
    bucket = aws_s3_bucket.example.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

  # Server-side encryption configuration using customer managed key
  resource "aws_s3_bucket_encryption" "example" {
    bucket = aws_s3_bucket.example.id

    server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = aws_kms_key.example.arn
          sse_algorithm     = "aws:kms"
        }
      }
    }

    # Use customer-managed key for S3 encryption
    kms_master_key_id = aws_kms_key.example.arn
    # Enable the use of customer-managed keys for S3 encryption
    use_customer_managed_key = true
  }

  # Bucket policy to restrict access to a specific IP address range
  resource "aws_s3_bucket_policy" "example" {
    bucket = aws_s3_bucket.example.id

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "AllowIPs"
          Effect = "Deny"
          Principal = "*"
          Action = "s3:*"
          Resource = "arn:aws:s3:::${aws_s3_bucket.example.id}/*"
          Condition = {
            NotIpAddress = {
              "aws:SourceIp": ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
            }
          }
        }
      ]
    })
  }

  # Bucket notification configuration
  resource "aws_s3_bucket_notification" "example" {
    bucket = aws_s3_bucket.example.id

    # This example configuration sends notifications to an SNS topic when
    # objects are created or deleted in the bucket.
    # Replace the SNS topic ARN with your desired SNS topic ARN.
    topic {
      topic_arn = "arn:aws:sns:us-west-2:123456789012:example-topic"
      events    = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
    }
  }
}

# Public access block configuration
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}