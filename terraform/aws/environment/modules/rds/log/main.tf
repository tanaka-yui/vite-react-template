resource "aws_cloudwatch_log_group" "database_log_group" {
  count = length(var.log_types)

  name              = "/aws/rds/cluster/${var.name}/${var.log_types[count.index]}"
  retention_in_days = var.retention_in_days

  tags = {
    Environment = "${var.name}/${var.log_types[count.index]}"
  }
}