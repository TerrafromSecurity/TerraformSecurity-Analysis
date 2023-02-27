provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "example-key"
  subnet_id     = "subnet-0c2e4c7a"
  
  ebs_block_device {
    device_name           = "/dev/sda1"
    encrypted             = true
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    encrypted             = true
    delete_on_termination = true
  }
  
  tags = {
    Name = "web-server"
  }

  metadata_options {
    http_tokens = "required"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}

resource "aws_eip" "public_ip" {
  instance = aws_instance.web_server.id
}

output "public_ip_address" {
  value = aws_eip.public_ip.public_ip
}