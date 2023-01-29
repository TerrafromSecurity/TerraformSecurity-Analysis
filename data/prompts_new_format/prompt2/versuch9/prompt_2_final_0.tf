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
  private_ips = [aws_eip.example.public_ip]
  security_groups = [aws_security_group.example.id]
}