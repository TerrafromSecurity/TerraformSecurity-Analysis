terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "dummy_key"
  subnet_id     = "subnet-1234567890abcdef0"
  vpc_security_group_ids = [
    "sg-01234567890abcdef",
  ]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "EC2 Instance"
  }
}