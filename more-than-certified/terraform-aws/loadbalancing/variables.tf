# loadbalancing/variables.tf

variable "public_sg" {}

variable "public_subnets" {}

variable "tg_port" {}

variable "vpc_id" {}

variable "lb_healthy_threshold" {}

variable "lb_unhealthy_threshold" {}

variable "lb_timeout" {}

variable "lb_interval" {}

variable "tg_protocol" {}

variable "listener_port" {}

variable "listener_protocol" {}