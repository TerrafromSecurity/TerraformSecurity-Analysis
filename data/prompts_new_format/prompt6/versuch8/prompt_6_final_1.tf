terraform {
  required_version = ">= 0.12.0"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  connection {
    host = aws_instance.example.public_ip
    user = "ubuntu"
  }

  tags = {
    Name = "example-instance"
  }

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }
}