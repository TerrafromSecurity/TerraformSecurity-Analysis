terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
		}
	}
}
# Provider Block: aws in us east 1
provider "aws" {
  region = "us-east-1"
}

# Create a AWS VPC resource with private network 10.0.0.0/16
resource "aws_vpc" "private_network" {
  cidr_block = "10.0.0.0/16"
}

# Create AWS subnets resource in private network 10.0.1.0/24 and map public ip on launch set true. Use VPC id
resource "aws_subnet" "private_network" {
  vpc_id = "${aws_vpc.private_network.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}
