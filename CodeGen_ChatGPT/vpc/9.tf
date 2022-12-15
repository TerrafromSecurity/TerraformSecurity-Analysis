# AWS provider block in region us-east-1 region and default profile
provider "aws" {
  region = "us-east-1"
  profile = "default"
}

# Resource block with an amazon VPC in private network 10.0.0.0/16
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}
