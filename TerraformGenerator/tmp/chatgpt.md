Here is an example of Terraform configuration code that deploys an AWS EC2 instance with the root block device encrypted:

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
}
```

Note: You can use different volume_type and encryption algorithm as per your requirement.

In this example, the `root_block_device` block has been added to the `aws_instance` resource and the `encrypted` parameter is set to true. This will encrypt the root block device of the EC2 instance at rest. The `delete_on_termination` parameter is set to true so that the volume will be deleted when the instance is terminated. 
