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

# create wafv2 ip set, use regional scope, assigna name and IPV4 address version. Set addresses to 4.3.3.4/32 and 2.8.1.9/32
resource "aws_wafv2_ip_set" "example" {
  scope = "REGIONAL"
  name  = "example-ip-set"
  ip_address_version = "IPV4"

  addresses = [
    "4.3.3.4/32",
    "2.8.1.9/32",
  ]
}
