provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "dummy_key_name"

  vpc_security_group_ids = [
    "sg-0123456789abcdef",
  ]

  ebs_block_device {
    device_name = "/dev/xvda"
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    encrypted   = true
  }

  tags = {
    Name = "web_server"
  }

  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("dummy_key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install apache2 -y",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2",
      "echo 'Hello World from Terraform' | sudo tee /var/www/html/index.html",
    ]
  }

  lifecycle {
    ignore_changes = [
      ebs_block_device,
    ]
  }
}