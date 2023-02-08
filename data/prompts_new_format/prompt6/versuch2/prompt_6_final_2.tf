provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  encrypted_ebs_volumes = true
  metadata_options = {
    http_tokens = "required"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.example.public_ip
    private_key = file("~/.ssh/id_rsa")
  }
}