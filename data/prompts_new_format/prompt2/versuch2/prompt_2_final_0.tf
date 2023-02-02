terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.0.0"
    }
  }
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
  vpc_id   = aws_vpc.example.id
  instance = aws_internet_gateway.example.id
}