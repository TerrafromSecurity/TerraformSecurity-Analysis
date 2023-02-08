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

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "web-server"
  }

  network_interface {
    network_interface_id = aws_network_interface.web_server.id
  }
}

resource "aws_network_interface" "web_server" {
  subnet_id = aws_subnet.web_server.id

  private_ips = ["10.0.1.100"]
  public_ips  = ["auto"]
}

resource "aws_subnet" "web_server" {
  vpc_id     = aws_vpc.web_server.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_vpc" "web_server" {
  cidr_block = "10.0.0.0/16"
}