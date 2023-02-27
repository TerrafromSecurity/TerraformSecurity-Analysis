provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "example_subnet" {
  vpc_id = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "example-subnet"
  }
}

resource "aws_internet_gateway" "example_gateway" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-gateway"
  }
}

resource "aws_eip" "example_eip" {
  vpc = true

  tags = {
    Name = "example-eip"
  }
}

resource "aws_nat_gateway" "example_nat_gateway" {
  allocation_id = aws_eip.example_eip.id
  subnet_id = aws_subnet.example_subnet.id

  tags = {
    Name = "example-nat-gateway"
  }
}

resource "aws_flow_log" "example_flow_log_rejects" {
  iam_role_arn = aws_iam_role.example_flow_log.arn
  traffic_type = "REJECT"
  log_destination {
    arn = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/vpcflowlogs/${aws_vpc.example_vpc.id}:*"
    iam_role_arn = aws_iam_role.example_flow_log.arn
  }

  depends_on = [
    aws_iam_role.example_flow_log
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "example_flow_log" {
  name_prefix = "example_flow_log"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "example-flow-log-role"
  }
}

output "nat_gateway_public_ip" {
  value = aws_eip.example_eip.public_ip
}