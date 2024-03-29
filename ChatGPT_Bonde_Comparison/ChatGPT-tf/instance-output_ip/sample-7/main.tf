terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Provider AWS block with region us east and default profile
provider "aws" {
  region  = "us-east"
  profile = "default"
}

# Create EC2 Instance with ami-0ff8a91507f77f867 and t2.micro
# Configure the AWS provider
provider "aws" {
  region  = "us-east"
  profile = "default"
}

# Create the EC2 instance
resource "aws_instance" "name_0" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
}

# output block, get EC2 Instance Public IP from vm
output "name_1" {
  value = aws_instance.name_0.public_ip
}