# Terraform Block with the AWS provider
provider "aws" {
  # AWS provider block with variable region
  region = var.region
}

# variable called ec2_ami_id with default ami-0915bcb5fa77e4892 and a condition to make sure string is an AMI id
variable "ec2_ami_id" {
  default = "ami-0915bcb5fa77e4892"

  # ensure that the value is a valid AMI ID
  condition = regex("^ami-[0-9a-f]{8}$", var.ec2_ami_id)
}
