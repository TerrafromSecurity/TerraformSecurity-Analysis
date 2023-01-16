resource "aws_kms_key" "example" {
  description = "example key"
  deletion_window_in_days = 10
  enable_key_rotation = true
}