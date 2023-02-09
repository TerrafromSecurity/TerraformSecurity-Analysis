resource "aws_vpc_flow_log" "example" {
  iam_role_arn = aws_iam_role.example.arn
  vpc_id       = aws_vpc.example.id
  log_destination_type = "cloud-watch-logs"
}