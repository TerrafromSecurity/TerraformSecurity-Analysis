I'm sorry but there seems to be a mistake in the report. The block device in the code has encryption enabled. Here's the code:

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  root_block_device {
    encryption = true
  }

  metadata_options {
    http_tokens = "required"
  }
}