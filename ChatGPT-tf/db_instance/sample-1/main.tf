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
resource "aws_rds_cluster" "name_0" {
  cluster_identifier   = "my-cluster"
  master_username      = "foo"
  master_password      = "barbaz"
  storage_encrypted    = true
  skip_final_snapshot  = true
  kms_key_id           = "arn:aws:kms:us-east-1:1234567890:key/my-kms-key"
  db_subnet_group_name = "my-db-subnet-group"
}

resource "aws_rds_cluster_instance" "name_1" {
  cluster_identifier   = aws_rds_cluster.name_0.id
  instance_class       = "t2.micro"
  allocated_storage    = 5
  skip_final_snapshot  = true
  db_subnet_group_name = "my-db-subnet-group"
}