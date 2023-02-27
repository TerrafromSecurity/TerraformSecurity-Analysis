terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.68.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "example" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.example.id
  instance_type = "t2.micro"

  metadata_options {
    http_tokens = "required"
  }
  
  tags = {
    Name = "example-instance"
  }

  root_block_device {
    volume_type = "gp2"
    encrypted = true
  }

  ebs_block_device {
    volume_type = "gp2"
    encrypted = true
  }
}