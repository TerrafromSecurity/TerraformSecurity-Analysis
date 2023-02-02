provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-new-bucket"
  acl    = "private"

  public_access_block {
    block_public_acls   = true
    block_public_policy = true
    ignore_public_objects_acl = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
        kms_master_key_id = "YOUR_KMS_MASTER_KEY_ID"
      }
    }
  }

  logging {
    target_bucket = "my-logging-bucket"
    target_prefix = "logs/example-bucket"
  }
}