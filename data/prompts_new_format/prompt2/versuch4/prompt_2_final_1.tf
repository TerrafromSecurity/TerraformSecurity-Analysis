terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "example" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_eip" "example" {
  vpc = true
}

resource "aws_network_interface" "example" {
  subnet_id = aws_subnet.example.id
  private_ips = ["10.0.0.10"]
  associate_with_private_ip = true
}

resource "aws_instance" "example" {
  ami           = "ami-0c7d566f1e26c2b65"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.example.id
    device_index         = 0
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_vpc.example.main_route_table_id
}

resource "aws_route" "example" {
  route_table_id = aws_route_table_association.example.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.example.id
}