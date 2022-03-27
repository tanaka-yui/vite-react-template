output "log_group_names" {
  value = aws_cloudwatch_log_group.database_log_group.*.name
}

output "log_types" {
  value = var.log_types
}