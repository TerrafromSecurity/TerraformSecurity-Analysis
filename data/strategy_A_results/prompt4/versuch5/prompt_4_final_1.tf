  root_block_device {
    volume_type = "gp2"
    encrypted   = true
  }
  metadata_options {
    http_token = "required"
  }
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"

  root_block_device {
    volume_type = "gp2"
    encrypted   = true
  }

  metadata_options {
    http_token = "required"
  }
}