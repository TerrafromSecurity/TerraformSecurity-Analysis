terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
		}
	}
}
# Provider Block AWS in region var.aws_region and default profile
provider "aws" {
  region = var.aws_region
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
resource "aws_security_group" "ssh_traffic" {
  name        = "ssh_traffic"
  description = "Allow SSH traffic"

  # Allow port 22 ingress
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all IPs and ports egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group for web traffic, allow port 80 and 443 ingress and all outbound traffic
resource "aws_security_group" "web" {
  name        = "web_traffic"
  description = "Security group for web traffic"

  ingress {
    description = "Allow traffic on ports 80 and 443"
    from_port   = 80
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 Instance with variable ec2 ami and instance type. Use vpc shh and vpc web security group ids
resource "aws_instance" "web_server" {
  ami           = var.ec2_ami
  instance_type = var.instance_type

  vpc_security_group_ids = [
    var.vpc_ssh_security_group_id,
    var.vpc_web_security_group_id
  ]
}
