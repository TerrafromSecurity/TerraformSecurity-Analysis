terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Provider AWS block with region us east
provider "aws" {
  region = "us-east-1"
}

# Create EC2 Instance with ami-0ff8a91507f77f867 and t2.micro
resource "aws_instance" "name_1" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
}

# Output block, create public DNS URL from vm
resource "aws_instance" "name_1" {
  # ...
}

output "name_2" {
  value = aws_instance.name_1.public_dns
}
