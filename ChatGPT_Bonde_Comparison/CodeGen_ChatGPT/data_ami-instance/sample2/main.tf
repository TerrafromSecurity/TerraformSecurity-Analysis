terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Provider AWS block with region set to us-east-1
provider "aws" {
  region = "us-east-1"
}

# data block: Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*"]
  }
}

# Create AWS instance with data ami id and t2.micro
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = "t2.micro"
}
