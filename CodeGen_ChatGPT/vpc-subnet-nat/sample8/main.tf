terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
		}
	}
}
# Provider Block: aws in us east 1.0
provider "aws" {
  region = "us-east-1"
}

# Create a AWS VPC resource with private network 10.0.0.0/16
resource "aws_vpc" "private_network" {
  cidr_block = "10.0.0.0/16"
}

# Create AWS subnets resource in private network 10.0.1.0/24 and map public ip on launch set true. Use VPC id
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.private_network.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# create a nat gateway, use private connectivity type and subnet id
resource "aws_nat_gateway" "private_gateway" {
  subnet_id = aws_subnet.private_subnet.id
  # Set private connectivity type
  allocation_id = aws_eip.private_eip.id
}
