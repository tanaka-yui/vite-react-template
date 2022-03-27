variable "name" {
  type = string
}

variable "log_types" {
  type = list(string)
}

variable "retention_in_days" {
  type    = number
  default = 7
}
