# Provider AWS with region us-east-1 region and default profile
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Create Variable that is a map of strings.
# The default is that key Terraform maps to true
# and Environment key maps to dev.
variable "flags" {
  default = {
    Terraform = true
    Environment = "dev"
  }

  type = map(string)
}
