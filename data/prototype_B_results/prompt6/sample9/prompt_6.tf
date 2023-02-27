terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Existing AMI
  instance_type = "t2.micro"
  key_name      = "example_key"
  subnet_id     = "subnet-123456789"

  # Other instance configuration settings...

  # Change the AMI to Ubuntu 16.04
  ami = "ami-0c55b159cbfafe1f0" # Ubuntu 16.04 AMI ID
}