terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.66.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami                = "ami-0c55b159cbfafe1f0"
  instance_type      = "t2.micro"
  key_name           = "example-key"
  user_data          = "echo 'Hello, World' > index.html"

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "example-instance"
  }

  vpc_security_group_ids = [aws_security_group.instance.id]

  # Assign a public IP to the instance
  associate_public_ip_address = true
}

resource "aws_security_group" "instance" {
  name_prefix = "example-instance"
  description = "Security group for example instance"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "Allow SSH access from 10.0.0.0/8"
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "Allow HTTP access from 10.0.0.0/8"
  }
}