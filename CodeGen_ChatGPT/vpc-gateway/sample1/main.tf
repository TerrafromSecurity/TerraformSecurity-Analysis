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
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# create internet gateway and use vpc id
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
