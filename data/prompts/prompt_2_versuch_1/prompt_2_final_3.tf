resource "aws_kms_key" "example" {
  description = "key for encrypting cloudwatch logs"
  enable_key_rotation = true
}