terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-12345678" # Replace with the desired Ubuntu 16.04 AMI ID
  instance_type = "t2.micro"
  key_name      = "example-key"
  vpc_security_group_ids = [
    "sg-12345678",
  ]

  # Replace with the existing EC2 instance ID
  id = "i-1234567890abcdef0"

  ebs_block_device {
    device_name = "/dev/xvda"
    encrypted   = true
  }

  root_block_device {
    volume_type = "gp2"
    encrypted   = true
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
  }
}