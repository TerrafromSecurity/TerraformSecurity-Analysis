terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 8
    encryption = true
    kms_key_id = aws_kms_key.example.arn
  }
  metadata_options {
    http_token = "required"
  }
}

resource "aws_kms_key" "example" {
  description = "example key"
  enable_key_rotation = true
}