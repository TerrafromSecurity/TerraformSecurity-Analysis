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
resource "aws_db_instance" "name_0" {
  allocated_storage = 5
  engine           = "mysql"
  engine_version   = "5.7"
  instance_class   = "t2.micro"
  name             = "my-rds-mysql-database"
  username         = "foo"
  password         = "barbaz"
  skip_final_snapshot = true
}