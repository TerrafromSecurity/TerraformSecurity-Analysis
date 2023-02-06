terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
		}
	}
}
# Terraform block with the AWS provider
provider "aws" {

}

# AWS provider block with variable region
provider "aws" {
  region = var.region
}

# variable called ec2_ami_id with default ami-0915bcb5fa77e4892 and a condition to make sure string is an AMI id
variable "ec2_ami_id" {
  default = "ami-0915bcb5fa77e4892"

  # Make sure the value is an AMI ID
  condition = regex(var.ec2_ami_id, "^ami-[0-9a-f]{8,}$")
}
