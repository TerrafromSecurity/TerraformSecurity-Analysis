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
resource "aws_elb" "example" {
  name            = "example-elb"
  internal        = false
  security_groups = ["sg-12345678"]
  subnets         = ["subnet-12345678"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }
}