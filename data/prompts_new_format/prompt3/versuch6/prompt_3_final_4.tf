resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"

  public_access_block {
    block_public_acls   = true
    block_public_policy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "logs/example-bucket/"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "log-bucket"
  acl    = "private"

  public_access_block {
    block_public_acls   = true
    block_public_policy = true
  }
}