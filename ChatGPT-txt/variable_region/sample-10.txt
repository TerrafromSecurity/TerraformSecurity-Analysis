# Provider AWS in region var.aws_region
provider "aws" {
  region = var.aws_region
}

# Create variable called aws_region that is a string type
# with default value "us-east-1"
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
