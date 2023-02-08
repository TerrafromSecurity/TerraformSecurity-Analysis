provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0e55e373c8ca96773"
  instance_type = "t2.micro"

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_token_required = true
  }

  tags = {
    Name = "example-instance"
  }
}