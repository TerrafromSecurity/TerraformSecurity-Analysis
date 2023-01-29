```
provider "aws" {
  region = "us-west-2"
}
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}
resource "aws_eip" "example" {
  vpc = true
}
resource "aws_eip_association" "example" {
  eip      = aws_eip.example.id
  instance = aws_internet_gateway.example.id
}
```

This is an example of a minimal Terraform configuration that creates a VPC and an Internet Gateway, and associates an Elastic IP to the Internet Gateway. Keep in mind that this example uses dummy values such as "us-west-2" region and "10.0.0.0/16" for the VPC CIDR block, you should use appropriate values for your specific use case.
