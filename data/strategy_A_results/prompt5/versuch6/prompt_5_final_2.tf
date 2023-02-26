provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }

  network_interface {
    associate_public_ip_address = true
  }

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }
}