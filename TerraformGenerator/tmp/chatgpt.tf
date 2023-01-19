terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.26.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"

  root_block_device {
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "example-instance"
  }
}