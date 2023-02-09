provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "example"
  }

  vpc_security_group_ids = ["sg-0123456789abcdef0"]

  network_interface {
    network_interface_id = "eni-0123456789abcdef0"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
  }
}

resource "aws_eip" "example" {
  instance = aws_instance.example.id
}