provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key-pair"
  subnet_id     = "subnet-1234567890abcdef0"

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }
}