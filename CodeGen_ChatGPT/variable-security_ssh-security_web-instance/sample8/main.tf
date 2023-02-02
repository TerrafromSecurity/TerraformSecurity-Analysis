# Provider Block AWS in region var.aws_region and default profile
provider "aws" {
  region  = var.aws_region
  profile = "default"
}

# Create variable called aws_region with default "us-east-1" and type string
variable "aws_region" {
  default = "us-east-1"
  type    = string
}

# variable called ec2_ami_id with default ami-0915bcb5fa77e4892 and type string
variable "ec2_ami_id" {
  default = "ami-0915bcb5fa77e4892"
  type    = string
}

# create number variable called ec2_instance_count with default 1 and type number
variable "ec2_instance_count" {
  default = 1
  type    = number
}

# create variable ec2_instance_type with default t3.micro and type string
variable "ec2_instance_type" {
  default = "t3.micro"
  type    = string
}

# Create Security Group for SSH Traffic
resource "aws_security_group" "ssh" {
  name        = "ssh_traffic"
  description = "Allow SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group for web traffic, allow port 80 and 443 ingress and all outbound traffic
resource "aws_security_group" "web_traffic" {
  # Create Security Group for web traffic
  name        = "web_traffic_sg"
  description = "Security group for web traffic"

  # Allow port 80 and 443 ingress
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 Instance with variable ec2 ami and instance type. Use vpc shh and vpc web security group ids

# Variable for the EC2 AMI ID
variable "ec2_ami" {
  type = string
}

# Variable for the EC2 instance type
variable "ec2_instance_type" {
  type = string
}

# VPC security group IDs
variable "vpc_ssh_security_group_id" {
  type = string
}

variable "vpc_web_security_group_id" {
  type = string
}

# Create the EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  security_groups = [
    var.vpc_ssh_security_group_id,
    var.vpc_web_security_group_id
  ]
}
