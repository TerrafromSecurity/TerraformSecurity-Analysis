terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_eip" "example" {
  vpc = true
}

resource "aws_network_interface" "example" {
  subnet_id = aws_subnet.example.id
  private_ips = ["10.0.1.5"]
  associate_with_private_ip = true
}

resource "aws_instance" "example" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  associate_public_ip_address = true
  network_interface {
    network_interface_id = aws_network_interface.example.id
  }
}