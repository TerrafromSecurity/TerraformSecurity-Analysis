resource "aws_flow_log" "example" {
  resource_id   = aws_vpc.example.id
  traffic_type  = "ALL"
  log_group_name = "example-log-group"
}