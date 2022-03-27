resource "aws_cloudwatch_event_rule" "ecr_event_rule" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  name = "${var.name}-codepipeline-ecr-event-rule"

  event_pattern = templatefile("${path.module}/json/cloudwatch-events-rule.json", {
    repository_name = var.repository.name
  })

  depends_on = [aws_codepipeline.codepipeline[0]]
}

resource "aws_cloudwatch_event_target" "ecr_event_target" {
  count = var.enable == true && var.deploy_mode == "ECS" ? 1 : 0

  rule      = aws_cloudwatch_event_rule.ecr_event_rule[0].name
  target_id = aws_cloudwatch_event_rule.ecr_event_rule[0].name
  arn       = aws_codepipeline.codepipeline[0].arn
  role_arn  = aws_iam_role.cloudwatch_events[0].arn

  depends_on = [
    aws_cloudwatch_event_rule.ecr_event_rule[0],
    aws_codepipeline.codepipeline[0],
    aws_iam_role.cloudwatch_events[0]
  ]
}