terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-west-2"   # replace with the desired region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # replace with the Ubuntu 16.04 AMI
  instance_type = "t2.micro"  # replace with the desired instance type

  metadata_options {
    http_tokens = "required"
  }

  # Enable encryption for all block devices
  ebs_block_device {
    device_name = "/dev/sda1"
    encrypted = true
  }

  # other resource configuration settings...

  lifecycle {
    ignore_changes = [ebs_block_device]
  }
}