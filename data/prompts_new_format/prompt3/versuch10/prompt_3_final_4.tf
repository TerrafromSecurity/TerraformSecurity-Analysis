resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
            kms_master_key_id = "alias/aws/s3"
        }
    }
  }
  public_access_block {
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
  }
  logging {
    target_bucket = "example-logging-bucket"
    target_prefix = "example-logging-prefix"
  }
}