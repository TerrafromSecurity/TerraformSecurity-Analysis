terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_instance_profile" "example_instance_profile" {
  name = "example-instance-profile"
  role = aws_iam_role.example_role.name
}

resource "aws_iam_role" "example_role" {
  name = "example-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "example_policy" {
  name = "example-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example_policy_attachment" {
  policy_arn = aws_iam_policy.example_policy.arn
  role = aws_iam_role.example_role.name
}

resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Existing AMI
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.example_instance_profile.name
  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_tokens = "required"
  }
  # other instance configuration parameters here...

  tags = {
    Name = "example-instance"
  }
}

# Change the instance AMI to Ubuntu 16.04
resource "aws_instance" "example_instance_new_ami" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 16.04 AMI
  instance_type = aws_instance.example_instance.instance_type
  iam_instance_profile = aws_iam_instance_profile.example_instance_profile.name
  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_tokens = "required"
  }
  # other instance configuration parameters here...

  tags = {
    Name = "example-instance"
  }
}