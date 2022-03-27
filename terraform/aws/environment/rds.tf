resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier              = local.db_name
  engine                          = local.engine
  engine_version                  = local.engine_version
  database_name                   = var.database.db_name
  port                            = 3306
  master_username                 = var.database.master_username
  master_password                 = var.database.master_password
  backup_retention_period         = var.database.backup_retention_period
  apply_immediately               = var.database.apply_immediately
  preferred_backup_window         = var.database.backup_window
  enabled_cloudwatch_logs_exports = var.database.enabled_cloudwatch_logs_exports
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db_cluster_parameter_group.name
  db_subnet_group_name            = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [
    aws_security_group.db_security_group.id
  ]

  depends_on = [
    aws_db_subnet_group.db_subnet_group,
    aws_rds_cluster_parameter_group.db_cluster_parameter_group,
    module.db_logs,
  ]
}

resource "aws_rds_cluster_instance" "rds_cluster_instance" {
  count                        = var.database.cluster_size
  identifier                   = "${local.db_name}-0${count.index + 1}"
  engine                       = local.engine
  engine_version               = local.engine_version
  cluster_identifier           = aws_rds_cluster.rds_cluster.cluster_identifier
  instance_class               = var.database.instance_class
  db_subnet_group_name         = aws_db_subnet_group.db_subnet_group.name
  db_parameter_group_name      = aws_db_parameter_group.db_parameter_group.name
  performance_insights_enabled = var.database.performance_insights

  depends_on = [
    aws_rds_cluster.rds_cluster,
    aws_db_subnet_group.db_subnet_group,
    aws_db_parameter_group.db_parameter_group,
  ]
}

module "db_logs" {
  source = "./modules/rds/log"

  name      = local.db_name
  log_types = var.database.enabled_cloudwatch_logs_exports
}
