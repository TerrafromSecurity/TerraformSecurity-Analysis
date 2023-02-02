resource "aws_vpc_gateway_attachment" "example" {
  vpc_id = "vpc-abcd1234"
  internet_gateway_id = aws_internet_gateway.example.id
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_eip" "example" {
  vpc = true
  network_interface = aws_network_interface.example.id
}

resource "aws_network_interface" "example" {
  subnet_id = aws_subnet.example.id
  private_ips = ["10.0.0.5"]
  security_groups = [aws_security_group.example.id]
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_security_group" "example" {
  name = "example"
  description = "Example security group"
  vpc_id = aws_vpc.example.id
}