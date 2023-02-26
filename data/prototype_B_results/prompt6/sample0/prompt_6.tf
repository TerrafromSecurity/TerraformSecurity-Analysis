terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  instance_id = "i-0123456789abcdef"
  ami = "ami-1234567890abcdef0" # This is the current AMI ID

  metadata_options {
    http_tokens = "required"
  }
}

data "aws_ami" "ubuntu1604" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}

# Update the AMI of the existing instance to Ubuntu 16.04
resource "aws_instance" "example" {
  instance_id = aws_instance.example.id
  ami = data.aws_ami.ubuntu1604.id

  metadata_options {
    http_tokens = "required"
  }
}