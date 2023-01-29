public_access_block {
  block_public_acls = true
  block_public_policy = true
  block_public_bucket = true
  ignore_public_acls = true
}
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"
  acl    = "private"
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = "arn:aws:kms:us-west-2:1234567890:key/abcdefgh-1234-5678-9012-abcdefghijkl"
        sse_kms_key_id = "arn:aws:kms:us-west-2:1234567890:key/abcdefgh-1234-5678-9012-abcdefghijkl"
      }
    }
  }
  
  logging {
    target_bucket = "example-log-bucket"
    target_prefix = "example-logs/"
  }
  
  public_access_block {
    block_public_acls = true
    block_public_policy = true
    block_public_bucket = true
    ignore_public_acls = true
  }
  versioning {
    enabled = true
  }
}