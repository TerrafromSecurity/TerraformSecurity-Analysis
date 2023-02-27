terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.59.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web_server" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "my-key-pair"
  vpc_security_group_ids = ["sg-123456789"]
  subnet_id = "subnet-123456789"
  
  tags = {
    Name = "web-server"
  }

  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  user_data = <<EOF
              #!/bin/bash
              # Install and configure web server
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
}