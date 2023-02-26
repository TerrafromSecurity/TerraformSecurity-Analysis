provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.example.id
  }

  tags = {
    Name = "example-instance"
  }
}

resource "aws_network_interface" "example" {
  subnet_id = aws_subnet.example.id

  private_ips = ["10.0.1.5"]

  tags = {
    Name = "example-interface"
  }
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "example-subnet"
  }
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}