# Add variables
variable "ext_port" {
  type = number
  default = 1880
  # Validation for variable
  validation {
    condition = var.ext_port <= 65535 && var.ext_port > 0
    error_message = "The external port must be 0 - 65535."
  }
}

variable "int_port" {
  type = number
  default = 1880
  
  validation {
    condition = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

variable "container_count" {
  type = number
  default = 1
}