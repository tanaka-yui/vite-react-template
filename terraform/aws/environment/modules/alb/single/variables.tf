variable "name" {}

variable "certificate_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "port" {
  type = string
}

variable "allow_http_hosts" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "allow_http_headers" {
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []
}

variable "health_check_path" {
  type    = string
  default = "/"
}



variable "health_check_matcher" {
  type = string
}
