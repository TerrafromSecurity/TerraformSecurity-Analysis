provider "aws" {
  region = "us-west-2" # Replace with your desired region
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16" # Replace with your desired CIDR block
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_eip" "example" {
  vpc      = true
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.example.id
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24" # Replace with your desired CIDR block
}

resource "aws_flow_log" "example" {
  name            = "example-flow-log"
  traffic_type    = "REJECT"
  log_destination = "arn:aws:logs:<region>:<account-id>:log-group:<log-group-name>"
  vpc_id          = aws_vpc.example.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}