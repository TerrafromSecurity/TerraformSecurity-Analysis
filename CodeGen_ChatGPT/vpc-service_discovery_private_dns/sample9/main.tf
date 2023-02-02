# Provider Block: aws in us east 1.0
provider "aws" {
  region = "us-east-1.0"
}

# Create a VPC resource with cidr block 10.0.0.0/16. Enable DNS support and DNS hostnames
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Make a service discovery private dns namespace resource. Give it the name 'example.terraform.local' and use vpc id
resource "aws_service_discovery_private_dns_namespace" "example" {
  name = "example.terraform.local"
  vpc  = "${aws_vpc.my_vpc.id}"
}
