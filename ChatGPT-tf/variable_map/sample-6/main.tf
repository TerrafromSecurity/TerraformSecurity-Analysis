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

# Create Variable that is a map of strings.
# The default is that key Terraform maps to true and
# Environment key maps to dev.
variable "name_0" {
  type        = map(string)
  default     = { Terraform = "true" }
  description = "Map of feature flags and their values"
}
