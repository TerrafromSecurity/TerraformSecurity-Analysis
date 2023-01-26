resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = "t2.micro"
  root_block_device {
    volume_encryption = true
  }
}
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = "t2.micro"
  root_block_device {
    volume_encryption = true
  }
  metadata_options {
    http_token = "required"
  }
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux2" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.20221117-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = "t2.micro"
  root_block_device {
    volume_encryption = true
  }
  metadata_options {
    http_token = "required"
  }
}