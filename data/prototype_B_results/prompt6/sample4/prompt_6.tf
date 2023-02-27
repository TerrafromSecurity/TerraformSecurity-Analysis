terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.76.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # replace with Ubuntu 16.04 AMI ID
  instance_type = "t2.micro"
  key_name      = "my-key-pair"
  security_groups = ["my-security-group"]

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "example-instance"
  }
}