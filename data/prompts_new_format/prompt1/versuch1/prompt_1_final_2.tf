terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  
  # Add the following block to enable encryption for all block devices
  root_block_device {
    volume_type = "gp2"
    encrypted = true
  }
  
  # Add the following block to enable session tokens for Instance Metadata Service
  metadata_options {
    http_tokens = "required"
  }
  
  tags = {
    Name = "example-instance"
  }
}