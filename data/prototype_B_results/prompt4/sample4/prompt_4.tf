provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens = "required"
  }

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 8
    volume_type           = "gp2"
    encrypted             = true
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    encrypted             = true
  }

  lifecycle {
    ignore_changes = [ebs_block_device, root_block_device]
  }
}