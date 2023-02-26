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

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_token = "required"
  }

  network_interface {
    associate_public_ip_address = true
  }
}

output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}