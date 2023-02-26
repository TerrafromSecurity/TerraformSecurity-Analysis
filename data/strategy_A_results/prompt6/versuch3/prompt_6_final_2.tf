provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0b89804080faf6c99"
  instance_type = "t2.micro"

  root_block_device {
    encryption = true
  }

  metadata_options {
    http_tokens = "required"
  }
}