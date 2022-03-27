resource "aws_ecs_service" "ecs_service" {
  count = var.enable == true ? 1 : 0

  name                               = "${var.name}-service"
  platform_version                   = var.service.platform_version
  cluster                            = var.cluster.id
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  desired_count                      = var.service.desired_count
  launch_type                        = var.service.launch_type
  task_definition                    = aws_ecs_task_definition.ecs_task_definition[0].arn

  load_balancer {
    container_name   = var.name
    container_port   = var.service.container_port
    target_group_arn = var.alb_target_group_arn
  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.ecs_security_group[0].id]
  }

  // task_definitionを変更したい場合はここをコメントアウトしてからapplyする
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      load_balancer,
    ]
  }

  deployment_controller {
    type = var.deploy_mode
  }

  depends_on = [
    aws_ecs_task_definition.ecs_task_definition[0],
    aws_security_group.ecs_security_group[0],
  ]
}
