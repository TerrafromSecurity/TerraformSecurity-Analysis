# Provider Block: aws in us east 1
provider "aws" {
  region = "us-east-1"
}

# Create a AWS VPC resource with cidr block 10.0.0.0/16
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# make a vpn gateway with the vpc id
resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = "${aws_vpc.main.id}"
}

# create a customer gateway with BGP ASN set to 65000, ip address 172.0.0.1 and type ipsec.1
resource "aws_customer_gateway" "cgw" {
  bgp_asn = 65000
  ip_address = "172.0.0.1"
  type = "ipsec.1"
}
