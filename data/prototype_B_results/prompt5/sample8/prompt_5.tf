provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "my-key-pair"
  
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  user_data     = <<-EOF
                  #!/bin/bash
                  sudo yum update -y
                  sudo yum install -y httpd
                  sudo systemctl start httpd
                  EOF
  
  tags = {
    Name = "Web Server"
  }

  vpc_security_group_ids = ["${aws_security_group.web_server.id}"]
  
}

resource "aws_security_group" "web_server" {
  name_prefix = "web_server_sg"
  description = "Security group for web server"
  
  ingress {
    description = "Allow inbound traffic on port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Allow outbound traffic to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

resource "aws_eip" "web_server_eip" {
  vpc = true
}

resource "aws_eip_association" "web_server_eip_assoc" {
  instance_id   = aws_instance.web_server.id
  allocation_id = aws_eip.web_server_eip.id
}