terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_eip" "example" {
  vpc = true
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.example.id
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_flow_log" "example" {
  iam_role_arn    = "arn:aws:iam::123456789012:role/vpc-flow-logs-role"
  traffic_type    = "REJECT"
  log_destination = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/vpc/flow-logs"
  vpc_id          = aws_vpc.example.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route" "example" {
  route_table_id         = aws_route_table.example.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.example.id
}
