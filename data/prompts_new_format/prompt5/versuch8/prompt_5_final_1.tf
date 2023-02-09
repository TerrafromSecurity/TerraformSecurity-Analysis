provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "web_server"
  }

  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }
}

resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow incoming traffic for web server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "web_server_ip" {
  vpc = true

  tags = {
    Name = "web_server_ip"
  }
}

resource "aws_network_interface_attachment" "web_server_attachment" {
  instance_id = aws_instance.web_server.id
  network_interface_id = aws_network_interface.web_server_interface.id
}

resource "aws_network_interface" "web_server_interface" {
  subnet_id = aws_subnet.public.id

  private_ips = [aws_instance.web_server.private_ip]

  tags = {
    Name = "web_server_interface"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}