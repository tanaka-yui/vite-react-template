vpc = {
  vpc_cidr              = "10.1.0.0/16"
  subnet_cidr_public_a  = "10.1.1.0/24"
  subnet_cidr_public_c  = "10.1.2.0/24"
  subnet_cidr_public_d  = "10.1.3.0/24"
  subnet_cidr_private_a = "10.1.16.0/20"
  subnet_cidr_private_c = "10.1.32.0/20"
  subnet_cidr_private_d = "10.1.48.0/20"
}

database = {
  db_name                         = ""
  instance_class                  = "db.t3.medium"
  cluster_size                    = 1
  master_username                 = "sample"
  master_password                 = ""
  allocated_storage               = 20
  skip_final_snapshot             = false
  performance_insights            = false
  apply_immediately               = false
  backup_retention_period         = "7"
  backup_window                   = "15:29-15:59"
  enabled_cloudwatch_logs_exports = ["audit"]
}

backend = {
  origin_domain_name       = ""
  domain_name              = ""
  container_port           = 80
  desired_count            = 1
  cpu                      = 512
  memory                   = 2048
  autoscale_capacity_min   = 1
  autoscale_capacity_max   = 2
  scale_down_cpu_threshold = 30
  scale_up_cpu_threshold   = 80
}
