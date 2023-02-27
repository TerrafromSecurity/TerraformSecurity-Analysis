terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.75.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_kms_key" "example" {
  description = "KMS key for EBS volume encryption"
  enable_key_rotation = true
}

resource "aws_ebs_volume" "example" {
  availability_zone = aws_instance.example.availability_zone
  encrypted         = true
  kms_key_id        = aws_kms_key.example.id

  # Create a new blank EBS volume to use as the root volume for the new AMI
  # Customize the size and volume type as needed
  size = 8
  type = "gp2"
}

resource "aws_volume_attachment" "example" {
  device_name = "/dev/xvda"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.example.id
}

resource "aws_instance" "example" {
  ami           = "ami-0323c3dd2da7fb37d" # existing AMI ID
  instance_type = "t2.micro"
  key_name      = "example_key"
  subnet_id     = "subnet-0eabea67"
  vpc_security_group_ids = [
    "sg-0a9e5d5c"
  ]
  
  metadata_options {
    http_tokens = "required"
  }

  ebs_block_device {
    device_name = "/dev/xvda"
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdc"
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    encrypted   = true
  }
}