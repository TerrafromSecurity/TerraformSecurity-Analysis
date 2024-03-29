terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Provider AWS in region "us-east-1"
provider "aws" {
  region = "us-east-1"
}

# Create RDS MySQL Database with 5 allocated storage and username foo and password barbaz. Instance class t2 micro and skip final snapshot
resource "aws_rds_instance" "name_0" {
  allocated_storage = 5
  engine           = "mysql"
  instance_class   = "t2.micro"
  name             = "my-db"
  username         = "foo"
  password         = "barbaz"
  skip_final_snapshot = true
}