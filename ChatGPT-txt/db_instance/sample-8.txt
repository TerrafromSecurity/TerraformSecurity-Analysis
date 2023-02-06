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
resource "aws_rds_cluster" "my_db" {
  engine                  = "mysql"
  engine_version          = "8.0"
  cluster_identifier      = "my-db-cluster"
  master_username         = "foo"
  master_password         = "barbaz"
  storage_encrypted       = true
  skip_final_snapshot     = true
  instance_class          = "t2.micro"
  allocated_storage       = 5
  backup_retention_period = 7
  backup_window           = "07:00-09:00"
  maintenance_window      = "Tue:03:00-Tue:04:00"

  parameter_group_name = "default.mysql8.0"

  vpc_security_group_ids = [
    aws_security_group.my_sg.id
  ]

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  tags = {
    Name = "my-db-cluster"
  }
}
