provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "example" {
  most_recent = true

  filter {
    name   = "name"
    values = ["my-ami-*"]
  }

  owners = ["self"]
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.example.id
  instance_type = "t2.micro"

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  ebs_block_device {
    encrypted = true
  }

  tags = {
    Name = "example-instance"
  }
}