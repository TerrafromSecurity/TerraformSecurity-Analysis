provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c84855ba95c71c99"
  instance_type = "t2.micro"

  ebs_block_device {
    device_name = "/dev/sda1"
    encrypted = true
  }

  volume_encryption {
    device_name = "/dev/sda1"
    kms_key_id  = "arn:aws:kms:us-west-2:1234567890:key/12345678-1234-1234-1234-1234567890ab"
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "example-instance"
  }
}