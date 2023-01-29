terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.34.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0f65671a86f061fcd"
  instance_type = "t2.micro"

  root_block_device {
    volume_type = "gp2"
    encrypted = true
    iops = 100
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "example-instance"
  }
}