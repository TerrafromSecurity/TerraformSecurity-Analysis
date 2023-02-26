provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["sg-0123456789abcdef0"]

  tags = {
    Name = "web_server"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    host     = self.public_ip
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y apache2"
    ]
  }
}

resource "aws_eip" "web_server_ip" {
  instance = aws_instance.web_server.id
}