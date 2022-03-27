resource "aws_cloudwatch_log_group" "log_group_backend" {
  name              = local.backend_name
  retention_in_days = 14

  tags = {
    Environment = local.env
    Application = local.backend_name
  }
}
