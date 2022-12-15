# Provider AWS with region us-east-1 region and default profile
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Create Variable that is a map of strings
variable "flags" {
  type        = map(string)
  default     = { Terraform = "true", Environment = "dev" }
}
