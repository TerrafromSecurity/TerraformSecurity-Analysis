terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.71.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example_instance" {
  ami           = "ami-0323c3dd2da7fb37d" # Replace with the Ubuntu 16.04 AMI ID
  instance_type = "t2.micro"
  key_name      = "example_key"
  security_groups = [
    "example_security_group",
  ]
  subnet_id = "example_subnet"

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }
}