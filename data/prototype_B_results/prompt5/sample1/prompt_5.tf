provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key-pair"
  security_groups = ["default"]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
  }

  root_block_device {
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  ebs_block_device {
    device_name  = "/dev/sdf"
    volume_size  = 10
    volume_type  = "gp2"
    encrypted    = true
    delete_on_termination = true
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
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
  vpc      = true
}

output "public_ip" {
  value = aws_eip.public_ip.public_ip
}