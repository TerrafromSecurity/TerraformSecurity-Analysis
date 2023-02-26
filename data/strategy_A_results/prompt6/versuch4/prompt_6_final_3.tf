provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_token = "required"
  }

  iam_instance_profile = "example-instance-profile"
}

resource "aws_iam_instance_profile" "example-instance-profile" {
  name = "example-instance-profile"

  roles = [
    "example-instance-role"
  ]
}

resource "aws_iam_role" "example-instance-role" {
  name = "example-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "example-instance-policy" {
  name = "example-instance-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "ec2:GetMetadata",
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })

  roles = [
    aws_iam_role.example-instance-role.name
  ]
}