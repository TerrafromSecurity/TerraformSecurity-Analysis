provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "example_gateway" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_eip" "example_eip" {
}

resource "aws_nat_gateway" "example_nat_gateway" {
  allocation_id = aws_eip.example_eip.id
  subnet_id     = aws_subnet.example_subnet.id
}

resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example_nat_gateway.id
  }
}

resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_security_group.id]
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    encrypted   = true
  }
}

resource "aws_security_group" "example_security_group" {
  name_prefix = "example"
  ingress {
    description = "Allow all incoming traffic from 10.0.0.0/8"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    description = "Allow all outgoing traffic to 10.0.0.0/8"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

resource "aws_flow_log" "example_flow_log" {
  iam_role_arn    = aws_iam_role.example_flow_log_role.arn
  traffic_type    = "REJECT"
  log_destination = aws_cloudwatch_log_group.example_flow_log_group.arn
  vpc_id          = aws_vpc.example_vpc.id
}

resource "aws_iam_role" "example_flow_log_role" {
  name = "example-flow-log-role"

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

resource "aws_iam_role_policy_attachment" "example_flow_log_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonVPCFlowLogsServiceRole"
  role       = aws_iam_role.example_flow_log_role.name
}

resource "aws_cloudwatch_log_group" "example_flow_log_group" {
  name = "example-flow-log-group"
}