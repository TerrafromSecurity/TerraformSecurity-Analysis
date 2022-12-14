terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Provider AWS block with region us east and default profile
provider "aws" {
  region = "us-east"
  profile = "default"
}

# Create EC2 Instance with ami-0ff8a91507f77f867 and t2.micro
resource "aws_instance" "example" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
}

# output block, get EC2 Instance Public IP from vm
output "public_ip" {
  value = aws_instance.example.public_ip
}