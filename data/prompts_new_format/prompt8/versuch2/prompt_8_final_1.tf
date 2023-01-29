terraform {
  provider "aws" {
    region = "us-east-1"
  }
}

data "aws_ami" "amazon_linux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = "t2.micro"
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    volume_type = "gp2"
    encrypted   = true
  }
}