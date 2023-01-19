Here is the updated Terraform code that enables at-rest encryption for the block device of the EC2 instance:

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.26.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"

  root_block_device {
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "example-instance"
  }
}
```

In this code, I added the `root_block_device` block, which enables encryption for the root block device of the EC2 instance. The `encrypted` field is set to `true`, which enables encryption. The `volume_type` and `delete_on_termination` fields are set to the default values.

Please note that the `ami` value may not exist in your region, you need to specify a valid `ami` id for your region. Also replace the `region` value with the region you want to launch the instance in.
