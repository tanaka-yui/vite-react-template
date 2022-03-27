resource "aws_ecs_task_definition" "ecs_task_definition" {
  count = var.enable == true ? 1 : 0

  family                   = "${var.name}-task"
  cpu                      = var.service.cpu
  memory                   = var.service.memory
  network_mode             = "awsvpc"
  requires_compatibilities = [var.service.launch_type]
  execution_role_arn       = var.service_task_execution_role.arn
  task_role_arn            = var.service_task_role == null ? null : var.service_task_role.arn
  container_definitions    = var.service.task_definition
  dynamic "volume" {
    for_each = var.efs_volume
    content {
      name = volume.value.name
      efs_volume_configuration {
        file_system_id = volume.value.file_system_id
        root_directory = volume.value.root_directory
      }
    }
  }

  depends_on = [
    var.service_task_execution_role,
    var.service_task_role
  ]
}