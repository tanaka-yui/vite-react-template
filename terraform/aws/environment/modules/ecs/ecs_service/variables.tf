variable "account_id" {}

variable "region" {}

variable "name" {}

variable "alb_target_group_arn" {
  type = string
}

variable "efs_volume" {
  type = list(object({
    name           = string
    file_system_id = string
    root_directory = string
  }))
  default = []
}

variable "maintenance" {
  type    = bool
  default = false
}

variable "enable" {
  type    = bool
  default = true
}

variable "cluster" {
  type    = any
  default = null
}

variable "repository" {
  type    = any
  default = null
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "service" {
  type = object({
    launch_type          = string
    platform_version     = string
    container_port       = number
    task_definition      = string
    desired_count        = number
    cpu                  = number
    memory               = number
    health_check_path    = string
    health_check_timeout = number
    health_check_code    = string
  })
}

variable "service_task_role" {
  type    = any
  default = null
}

variable "service_task_execution_role" {
  type    = any
  default = null
}

variable "autoscale_capacity" {
  type = object({
    min                      = number
    max                      = number
    scale_down_cpu_threshold = number
    scale_up_cpu_threshold   = number
  })
}

variable "deploy_mode" {
  type    = string
  default = "ECS"
}