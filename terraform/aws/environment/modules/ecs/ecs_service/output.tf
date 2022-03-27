output "service_name" {
  value = length(aws_ecs_service.ecs_service) == 1 ? aws_ecs_service.ecs_service[0].name : ""
}
