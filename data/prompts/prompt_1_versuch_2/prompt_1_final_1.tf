resource "aws_instance" "example" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
  root_block_device {
    volume_type = "gp2"
    encrypted = true
    delete_on_termination = true
  }
  metadata_options {
    http_tokens = "required"
  }
}