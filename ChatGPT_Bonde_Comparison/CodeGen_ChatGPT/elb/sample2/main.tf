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
resource "aws_elb" "my_elb" {
  listener {
    instance_port = 80
    lb_port       = 80
    lb_protocol   = "http"
  }

  # Other configuration options, such as number of instances and health check settings,
  # can be added here.
}