terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.example.id]

  key_name = "my-key-pair"

  tags = {
    Name = "example-instance"
  }
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "ip" {
  vpc = true
}

resource "aws_network_interface_attachment" "example" {
  instance_id = aws_instance.example.id
  network_interface_id = aws_network_interface.example.id
  device_index = 0
}

resource "aws_network_interface" "example" {
  subnet_id = aws_subnet.example.id
  private_ips = ["10.0.1.100"]
  associate_with_private_ip = true
  associate_public_ip_address = true
}

resource "aws_subnet" "example" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "example-vpc"
  }
}