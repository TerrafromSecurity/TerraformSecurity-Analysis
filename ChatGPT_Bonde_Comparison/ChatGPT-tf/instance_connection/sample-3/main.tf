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
resource "aws_instance" "name_0" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
}

# Connection block for ssh with the public IP
resource "aws_eip" "name_1" {
  instance = aws_instance.name_0.id
}

output "name_2" {
  value = aws_eip.name_1.public_ip
}