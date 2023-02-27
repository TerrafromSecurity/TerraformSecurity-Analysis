provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0b69ea66ff7391e80" // Ubuntu 16.04 LTS
  instance_type = "t2.micro"
  key_name      = "my_key_pair"
  security_groups = ["web_server_security_group"]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/my_key_pair.pem")
    host        = aws_instance.web_server.public_ip
  }

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "Web Server"
  }
}

resource "aws_security_group" "web_server_security_group" {
  name_prefix = "web_server_"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}