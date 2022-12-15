# Provider Block: aws in us east 1.0
provider "aws" {
  region = "us-east-1"
}

# Create a AWS VPC resource with private network 10.0.0.0/16
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Create AWS subnets resource in private network 10.0.1.0/24 and map public ip on launch set true. Use VPC id
resource "aws_subnet" "example" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# create a nat gateway, use private connectivity type and subnet id
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id = aws_subnet.example.id
  private_ip = "10.0.1.5"
}
