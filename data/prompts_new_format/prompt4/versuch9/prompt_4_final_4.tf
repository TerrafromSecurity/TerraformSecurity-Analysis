provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  encryption_enabled = true
  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_token = "required"
  }
}