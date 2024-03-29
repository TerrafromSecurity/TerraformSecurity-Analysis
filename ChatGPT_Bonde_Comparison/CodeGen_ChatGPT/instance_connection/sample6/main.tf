terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Provider Block AWS with region us east 1 and default profile
provider "aws" {
  region = "us-east-1"
  profile = "default"
}

# Create EC2 Instance with ami-0ff8a91507f77f867 instance type t2.micro. Connection Block for ssh with the public ip
resource "aws_instance" "example" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
}

# Connection Block for ssh with the public ip
resource "aws_eip" "example" {
  instance = aws_instance.example.id
}

output "public_ip" {
  value = aws_eip.example.public_ip
}