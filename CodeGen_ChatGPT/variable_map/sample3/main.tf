# Provider AWS with region us-east-1 region and default profile
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Create Variable that is a map of strings
variable "flags" {
  # The default is that key Terraform maps to true
  # and Environment key maps to dev
  default = {
    Terraform = true
    Environment = "dev"
  }

  # Make sure the variable is a map of strings
  type = map(string)
}
