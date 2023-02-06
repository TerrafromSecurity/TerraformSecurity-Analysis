terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
		}
	}
}
# Provider AWS in region "us-east-1"
provider "aws" {
  region = "us-east-1"
}

# create workspace ip group, give it a name.
resource "aws_workspaces_ip_group" "example" {
  name = "example-ip-group"

  # Set a rule with source 150.24.14.0/24 and description LA
  rule {
    source = "150.24.14.0/24"
    description = "LA"
  }
}
