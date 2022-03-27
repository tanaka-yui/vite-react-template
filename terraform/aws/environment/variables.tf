variable "account_id" {
  default = ""
}

variable "region" {
  default = ""
}

variable "product_name" {
  default = ""
}

variable "origin_access_key" {
  default = ""
}

variable "vpc" {
  type = map(string)

  default = {
    vpc_cidr              = ""
    subnet_cidr_public_a  = ""
    subnet_cidr_public_c  = ""
    subnet_cidr_public_d  = ""
    subnet_cidr_private_a = ""
    subnet_cidr_private_c = ""
    subnet_cidr_private_d = ""
  }
}


variable "database" {
  type = object({
    db_name                         = string
    instance_class                  = string
    cluster_size                    = number
    master_username                 = string
    master_password                 = string
    allocated_storage               = number
    skip_final_snapshot             = bool
    performance_insights            = bool
    apply_immediately               = bool
    backup_retention_period         = string
    backup_window                   = string
    enabled_cloudwatch_logs_exports = list(string)
  })
}

variable "backend" {
  type = object({
    origin_domain_name       = string
    domain_name              = string
    container_port           = number
    desired_count            = number
    cpu                      = number
    memory                   = number
    autoscale_capacity_min   = number
    autoscale_capacity_max   = number
    scale_down_cpu_threshold = number
    scale_up_cpu_threshold   = number
  })
}

variable "maintenance_server_allow_hosts" {
  type = list(object({
    cidr_block  = string
    description = string
  }))
  default = []
}
