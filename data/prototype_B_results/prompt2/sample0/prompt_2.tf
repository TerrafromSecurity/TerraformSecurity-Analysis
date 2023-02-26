provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy_document" "example" {
  statement {
    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "example-vpc"
  }

  provisioner "local-exec" {
    command = "aws ec2 enable-vpc-flow-logs --vpc-id ${aws_vpc.example.id} --traffic-type REJECT"
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
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.example.id

  tags = {
    Name = "example-subnet"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  depends_on = [
    aws_nat_gateway.example,
  ]
}

resource "aws_cloudwatch_log_group" "example" {
  name = "example-vpc-flow-logs"

  retention_in_days = 30
}

resource "aws_iam_role" "example" {
  name = "example-flow-log-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.example.name
}

resource "aws_flow_log" "example" {
  iam_role_arn    = aws_iam_role.example.arn
  log_destination = aws_cloudwatch_log_group.example.arn
  traffic_type    = "REJECT"
}
