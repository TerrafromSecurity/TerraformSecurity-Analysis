# Terraform block
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

# AWS provider block
provider "aws" {
  region = "us-west-2" # Change to your preferred region
}

# EC2 instance resource block
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Change to the AMI ID for your preferred OS
  instance_type = "t2.micro" # Specify the desired instance type
  key_name      = "example_key" # Change to your preferred key pair name
  vpc_security_group_ids = ["sg-0123456789abcdef"] # Change to your preferred security group ID
  subnet_id     = "subnet-0123456789abcdef" # Change to your preferred subnet ID
  
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 8 # Change to your preferred root volume size
    encrypted   = true # Set the encrypted parameter to true to enable encryption for the root block device
  }
}