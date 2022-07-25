variable "service_name" {}

variable "service_port" {}

variable "cpu" {}

variable "memory" {}

variable "container_definitions" {}

variable "desired_count" {}

variable "enable_execute_command" {}

variable "security_groups" {}

variable "ecs_subnets" {}

variable "alb-tg-arn" {}

variable "min_scaling_capacity" {
  default = 1
}

variable "max_scaling_capacity" {
  default = 4
}

variable "tg_arn_suffix" {}

variable "alb_arn_suffix" {}