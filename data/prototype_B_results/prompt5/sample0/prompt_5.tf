terraform {
  required_version = ">= 0.13"
  
  # Add your AWS provider configuration here
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  # Replace with your own key pair name and security group ID
  key_name      = "my-key-pair"
  vpc_security_group_ids = ["sg-0123456789abcdef"]
  
  tags = {
    Name = "Web Server"
  }

  # Set up the public IP address
  associate_public_ip_address = true
  
  # Add any additional configuration options here
}