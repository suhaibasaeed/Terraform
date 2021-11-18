# Add variables
variable "ext_port" {
  type = list
  # Validation for variable
  
  validation {
    # Add max/min funcs and spread operator as variable is a list
    condition = max(var.ext_port...) <= 65535 && min(var.ext_port...) > 0
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

locals {
  # Number of items in ext_port list
  container_count = length(var.ext_port)
}
