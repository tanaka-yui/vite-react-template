#--------------------------------------------------------------
# Ecs Task Execution Role
#--------------------------------------------------------------
resource "aws_iam_role" "ecs_task_role_execution_role" {
  name               = "${local.name}-ecs-task-execution-role"
  assume_role_policy = file("${path.module}/template/ecs/role/ecs-task-assume-role.json")
}

resource "aws_iam_role_policy" "ecs_task_execution_role_policy" {
  role   = aws_iam_role.ecs_task_role_execution_role.id
  policy = file("${path.module}/template/ecs/role/ecs-task-execution-role-policy.json")

  depends_on = [aws_iam_role.ecs_task_role_execution_role]
}

#--------------------------------------------------------------
# Ecs Task Role
#--------------------------------------------------------------
resource "aws_iam_role" "ecs_task_role_backend" {
  name               = "${local.name}-ecs-task-mobile-backend-role"
  assume_role_policy = file("${path.module}/template/ecs/role/ecs-task-assume-role.json")
}

resource "aws_iam_role_policy" "ecs_task_role_policy_mobile_backend" {
  role = aws_iam_role.ecs_task_role_backend.id
  policy = templatefile("${path.module}/template/ecs/role/ecs-task-backend-role-policy.json", {
    account_id = var.account_id
  })

  depends_on = [
    aws_iam_role.ecs_task_role_backend,
  ]
}
