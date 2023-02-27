terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.67.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = "subnet-1234567890abcdef0"

  metadata_options {
    http_tokens = "required"
  }

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/xvdf"
    volume_size = 10
    encrypted   = true
  }

  root_block_device {
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name = "example-instance"
  }
}