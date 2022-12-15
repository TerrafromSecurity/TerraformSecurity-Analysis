# Provider Block: aws in us east 1
provider "aws" {
  region = "us-east-1"
}

# Create a AWS VPC resource with private network 10.0.0.0/16
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  # Additional VPC configuration goes here...
}
