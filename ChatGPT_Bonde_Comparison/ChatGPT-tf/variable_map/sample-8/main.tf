terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
		}
	}
}
# Provider AWS with region us-east-1 region and default profile
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Create Variable that is a map of strings
variable "name_0" {
  type    = map(string)
  default = {
    # The default is that key Terraform maps to true
    "Terraform" = "true"
    # and Environment key maps to dev
    "Environment" = "dev"
  }
}
