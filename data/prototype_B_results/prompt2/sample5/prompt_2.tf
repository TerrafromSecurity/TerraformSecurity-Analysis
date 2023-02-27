provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "example"
  }
}

resource "aws_flow_log" "example" {
  iam_role_arn = "arn:aws:iam::123456789012:role/flowlogs_role"
  traffic_type = "REJECT"
  log_destination {
    // S3 bucket or CloudWatch Log Group ARN
  }
  vpc_id = aws_vpc.example.id
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_eip" "example" {
  vpc = true
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id = aws_subnet.example.id
}

resource "aws_subnet" "example" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = "example"
  }
}