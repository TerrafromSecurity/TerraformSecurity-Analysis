terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    time = {
      source  = "hashicorp/time"
    }
  }
}

# Provider block AWS with region us east
provider "aws" {
  region = "us-east-1"
}

# Resource block with an EC2 instance with t2.micro instance type and ami-0ff8a91507f77f867
provider "aws" {
  region = "us-east-1"
}

# Time sleep resource block, Wait for 90 seconds after creating ec2 instance
resource "aws_cloudwatch_event_rule" "name_0" {
  schedule_expression = "rate(90 seconds)"
}

resource "aws_cloudwatch_event_target" "name_1" {
  rule = "${aws_cloudwatch_event_rule.name_0.name}"
  target_id = "wait_for_ec2_target"
  arn = "arn:aws:lambda:us-east-1:123456789012:function:wait_for_ec2"
}
