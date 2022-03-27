locals {
  service_resource_id = "service/${var.cluster.name}/${var.enable == true ? aws_ecs_service.ecs_service[0].name : ""}"
}

resource "aws_appautoscaling_target" "appautoscaling_target" {
  count = var.enable == true ? 1 : 0

  service_namespace  = "ecs"
  resource_id        = local.service_resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.autoscale_capacity.min
  max_capacity       = var.autoscale_capacity.max
}

resource "aws_appautoscaling_policy" "appautoscaling_policy_scale_up" {
  count = var.enable == true ? 1 : 0

  name               = "${aws_ecs_service.ecs_service[0].name}-scale-up"
  service_namespace  = "ecs"
  resource_id        = local.service_resource_id
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 600
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.appautoscaling_target[0]]
}

resource "aws_appautoscaling_policy" "appautoscaling_policy_scale_down" {
  count = var.enable == true ? 1 : 0

  name               = "${aws_ecs_service.ecs_service[0].name}-scale-down"
  service_namespace  = "ecs"
  resource_id        = local.service_resource_id
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 600
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.appautoscaling_target[0]]
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm_cpu_high" {
  count = var.enable == true ? 1 : 0

  alarm_name          = "${aws_ecs_service.ecs_service[0].name}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.autoscale_capacity.scale_up_cpu_threshold

  dimensions = {
    ClusterName = var.cluster.name
    ServiceName = aws_ecs_service.ecs_service[0].name
  }

  alarm_actions = [aws_appautoscaling_policy.appautoscaling_policy_scale_up[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm_cpu_low" {
  count = var.enable == true ? 1 : 0

  alarm_name          = "${aws_ecs_service.ecs_service[0].name}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.autoscale_capacity.scale_down_cpu_threshold

  dimensions = {
    ClusterName = var.cluster.name
    ServiceName = aws_ecs_service.ecs_service[0].name
  }

  alarm_actions = [aws_appautoscaling_policy.appautoscaling_policy_scale_down[0].arn]
}
