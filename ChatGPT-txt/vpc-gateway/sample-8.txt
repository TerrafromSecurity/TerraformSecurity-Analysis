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
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  # Other optional configuration options for the VPC
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}
