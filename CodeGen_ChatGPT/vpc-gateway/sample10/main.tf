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
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  # create internet gateway and use vpc id
  internet_gateway_id = "${aws_internet_gateway.my_igw.id}"
}

# create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = "${aws_vpc.my_vpc.id}"
}
