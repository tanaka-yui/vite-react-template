locals {
  name            = "${terraform.workspace}-${var.product_name}"
  env             = terraform.workspace
  region          = "ap-northeast-1"
  log_stream_name = "ecs-log"

  cluster_name = "${local.name}-cluster"
  backend_name = "${local.name}-api"
  front_name   = "${local.name}-front"
  db_name      = "${local.name}-db"

  x_origin_access_key = "x-origin-access-key"

  maintenance_server_allow_hosts = []
}
