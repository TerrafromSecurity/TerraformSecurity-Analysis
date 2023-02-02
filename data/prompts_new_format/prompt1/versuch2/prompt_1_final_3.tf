encryption = "aws:kms"
http_token = "required"
resource "aws_instance" "example" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 8
    encryption = "aws:kms"
  }
  metadata_options {
    http_token = "required"
  }
}