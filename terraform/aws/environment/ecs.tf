resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.cluster_name
}

module "ecs_service_backend" {
  source               = "./modules/ecs/ecs_service"
  name                 = local.backend_name
  account_id           = var.account_id
  region               = var.region
  alb_target_group_arn = module.alb_backend.target_group_arn
  cluster              = aws_ecs_cluster.ecs_cluster
  repository           = aws_ecr_repository.ecr_repository_backend
  vpc_id               = aws_vpc.vpc.id
  private_subnet_ids = [
    aws_subnet.subnet_private_a.id,
    aws_subnet.subnet_private_c.id,
  ]
  service = {
    task_definition = templatefile("${path.module}/template/ecs/task_definition/task_definition.json", {
      name           = local.backend_name
      region         = local.region
      repository_url = aws_ecr_repository.ecr_repository_backend.repository_url
      stream_prefix  = local.log_stream_name
    })
    container_port       = var.app.container_port
    desired_count        = var.app.desired_count
    cpu                  = var.app.cpu
    memory               = var.app.memory
    launch_type          = "FARGATE"
    platform_version     = "1.4.0"
    health_check_path    = "/api/health"
    health_check_timeout = 5
    health_check_code    = "200"
  }
  service_task_execution_role = aws_iam_role.ecs_task_role_execution_role
  service_task_role           = aws_iam_role.ecs_task_role_backend
  autoscale_capacity = {
    min                      = var.app.autoscale_capacity_min
    max                      = var.app.autoscale_capacity_max
    scale_down_cpu_threshold = var.app.scale_down_cpu_threshold
    scale_up_cpu_threshold   = var.app.scale_up_cpu_threshold
  }

  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet_private_a,
    aws_subnet.subnet_private_c,
    aws_ecs_cluster.ecs_cluster,
    aws_ecr_repository.ecr_repository_backend,
    aws_cloudwatch_log_group.log_group_backend,
    aws_iam_role.ecs_task_role_execution_role,
    aws_iam_role.ecs_task_role_backend,
    module.alb_backend,
  ]
}