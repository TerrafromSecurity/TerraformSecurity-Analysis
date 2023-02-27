provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0123456789abcdef0"

  tags = {
    Name = "web-server"
  }

  security_groups = ["sg-0123456789abcdef0"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 80 &
              EOF

  metadata_options {
    http_tokens = "required"
  }

  # Create a public IP address for this instance
  associate_public_ip_address = true

  ebs_block_device {
    device_name = "/dev/xvda"
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/xvdf"
    encrypted   = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}