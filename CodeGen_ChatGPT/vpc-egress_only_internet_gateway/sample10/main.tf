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

# create vpc resource, use cidr block 10.1.0.0/16 and assign generated ipv6 cidr block
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.1.0.0/16"
  assign_generated_ipv6_cidr_block = true
}

# create an egress only internet gateway, use vpc id
resource "aws_egress_only_internet_gateway" "my_egress_only_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
}
