# Provider Block: aws in us east 1.0
provider "aws" {
  region = "us-east-1"
}

# Create a AWS VPC resource with private network 10.0.0.0/16
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  # Create AWS subnets resource in private network 10.0.1.0/24 and map public ip on launch set true
  resource "aws_subnet" "private" {
    vpc_id      = aws_vpc.main.id
    cidr_block  = "10.0.1.0/24"
    map_public_ip_on_launch = true
  }

  # create a nat gateway, use private connectivity type and subnet id
  resource "aws_nat_gateway" "main" {
    subnet_id            = aws_subnet.private.id
    allocation_id        = aws_eip.main.id
    private_ip           = "10.0.1.5"
    connectivity_type    = "private"
  }
}
