terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
		}
	}
}
# Provider Block AWS in region var.name_0 and default profile
provider "aws" {
  region = var.name_0
  profile = "default"
}

# Create variable called aws_region with default "us-east-1" and type string
variable "name_0" {
  default = "us-east-1"
  type    = string
}

# variable called ec2_ami_id with default ami-0915bcb5fa77e4892 and type string
variable "name_1" {
  default = "ami-0915bcb5fa77e4892"
  type    = string
}

# create number variable called ec2_instance_count with default 1 and type number
variable "name_2" {
  default = 1
  type    = number
}

# create variable ec2_instance_type with default t3.micro and type string
variable "name_7" {
  default = "t3.micro"
  type    = string
}

# Create Security Group for SSH Traffic, allow port 22 ingress and all IP and ports egress
resource "aws_security_group" "name_4" {
  name        = "ssh"
  description = "Allow SSH traffic on port 22"

  ingress {
    description = "SSH traffic"
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
resource "aws_security_group" "name_5" {
  name        = "web-traffic"
  description = "Security group for web traffic"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 Instance with variable ec2 ami and instance type. Use vpc shh and vpc web security group ids

variable "name_6" {
  type = string
}

variable "name_7" {
  type = string
}

variable "name_8" {
  type = string
}

variable "name_9" {
  type = string
}

resource "aws_instance" "name_10" {
  ami           = var.name_6
  instance_type = var.name_7

  vpc_security_group_ids = [
    var.name_8,
    var.name_9,
  ]
}
