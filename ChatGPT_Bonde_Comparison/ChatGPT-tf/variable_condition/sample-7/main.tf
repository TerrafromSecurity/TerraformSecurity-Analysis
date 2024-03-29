terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
		}
	}
}
# Terraform Block with the AWS provider

provider "aws" {
}

# AWS provider block with variable region

variable "name_0" {
  default = "us-east-1"
}

# Variable called ec2_ami_id with default ami-0915bcb5fa77e4892 and a condition to make sure string is an AMI id

variable "name_1" {
  default     = "ami-0915bcb5fa77e4892"
  description = "The AMI ID to use for the EC2 instance"

  # Make sure that the value is a valid AMI ID
  condition   = regex("^ami-[0-9a-z]{8,}$", var.name_1)
}
