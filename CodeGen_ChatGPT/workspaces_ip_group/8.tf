# Provider AWS in region "us-east-1"
provider "aws" {
  region = "us-east-1"
}

# create workspace ip group, give it a name.
resource "aws_workspaces_ip_group" "example" {
  name = "example-ip-group"

  rules {
    source = "150.24.14.0/24"
    description = "LA"
  }
}
