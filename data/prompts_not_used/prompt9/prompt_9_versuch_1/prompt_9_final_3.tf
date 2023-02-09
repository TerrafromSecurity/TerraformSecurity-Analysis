provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"

  volume_encryption_key = "arn:aws:kms:us-east-1:1234567890:key/example"
  iam_instance_profile = "arn:aws:iam::1234567890:instance-profile/example"

  metadata_options {
    http_token = "required"
  }
}

output "public_dns" {
  value = aws_instance.example.public_dns
}