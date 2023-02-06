terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
		}
	}
}
# Terraform block with the AWS provider
provider "aws" {
  # AWS provider block with variable region
  region = var.region
}

# Variable called ec2_ami_id with default ami-0915bcb5fa77e4892
# and a condition to make sure string is an AMI id
variable "ec2_ami_id" {
  default     = "ami-0915bcb5fa77e4892"
  description = "The AMI ID to use for the EC2 instance"

  # Make sure the value is a valid AMI ID
  # NOTE: This validation only checks the format of the AMI ID, not
  # whether it is an actual AMI ID that exists in the specified region.
  # You should add additional logic to validate the AMI ID if necessary.
  validation {
    condition     = regex("^ami-[a-fA-F0-9]{8,}$")
    error_message = "ec2_ami_id must be a valid AMI ID (e.g. ami-abc123456)"
  }
}
