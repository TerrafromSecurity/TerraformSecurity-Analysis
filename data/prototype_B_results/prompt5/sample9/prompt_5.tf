terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "my-keypair"
  security_groups = ["web-server-sg"]
  subnet_id = "subnet-0c921084fa05a37ea"

  tags = {
    Name = "web-server"
  }

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp2"
    encrypted = true
  }
}

resource "aws_eip" "web_server_eip" {
  instance = aws_instance.web_server.id
}

output "web_server_public_ip" {
  value = aws_eip.web_server_eip.public_ip
}