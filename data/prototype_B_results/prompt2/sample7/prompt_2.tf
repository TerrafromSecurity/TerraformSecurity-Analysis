terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.68.0"
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

  tags = {
    Name = "example-vpc"
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
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_iam_role" "example" {
  name = "vpc-flow-logs"

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
}

resource "aws_kms_key" "example" {
  description = "KMS key for encrypting CloudWatch logs"
}

resource "aws_cloudwatch_log_group" "example" {
  name = "/aws/vpc/flow-logs"

  retention_in_days = 7
  kms_key_id        = aws_kms_key.example.id
}

resource "aws_flow_log" "example" {
  iam_role_arn    = aws_iam_role.example.arn
  log_destination = aws_cloudwatch_log_group.example.arn
  traffic_type    = "REJECT"
  vpc_id          = aws_vpc.example.id
}

resource "aws_kms_alias" "example" {
  name = "alias/cloudwatch-log-kms-key"
  target_key_id = aws_kms_key.example.id
}

output "gateway_ip" {
  value = aws_eip.example.public_ip
}