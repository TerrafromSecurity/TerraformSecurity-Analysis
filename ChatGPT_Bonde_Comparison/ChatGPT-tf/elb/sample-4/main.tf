terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Provider block with AWS in us-east-1 region
provider "aws" {
  region = "us-east-1"
}

# Resource, create AWS ELB that listens for instance port 80 and lb port 80
resource "aws_elb" "name_0" {
  name               = "example-elb"
  security_groups    = ["sg-12345678"]
  subnets            = ["subnet-12345678", "subnet-23456789"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}