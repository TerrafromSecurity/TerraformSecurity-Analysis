provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_flow_log" "example" {
  iam_role_arn    = aws_iam_role.example.arn
  traffic_type    = "REJECT"
  log_destination = aws_cloudwatch_log_group.example.arn
  vpc_id          = aws_vpc.example.id
}

resource "aws_kms_key" "example" {
  description = "CMK for encrypting CloudWatch log data"
  enable_key_rotation = true
}

resource "aws_cloudwatch_log_group" "example" {
  name_prefix = "flow-logs"
  kms_key_id  = aws_kms_key.example.key_id
}

resource "aws_cloudwatch_log_stream" "example" {
  name            = "flow-logs"
  log_group_name  = aws_cloudwatch_log_group.example.name
  depends_on = [
    aws_cloudwatch_log_group.example,
  ]
}

resource "aws_iam_role" "example" {
  name = "flow-log-role"
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

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonVPCFlowLogsRole"
  role       = aws_iam_role.example.name
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_eip" "example" {
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example.id
  associate_public_ip_address = true
  metadata_options {
    http_tokens = "required"
  }
  
  root_block_device {
    encrypted = true
  }
}

resource "aws_subnet" "example" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.example.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  depends_on = [
    aws_internet_gateway.example,
  ]
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}