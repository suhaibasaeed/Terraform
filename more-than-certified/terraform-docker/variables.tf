
variable "image" {
  type = map
  description = "Image for container"
  default = {
    dev = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
    }
}
# Add variables
variable "ext_port" {
  type = map
  # Validation for variable
  # Different rule for prod and dev env. Use key to reference map
  validation {
    # Add max/min funcs and spread operator as variable is a list
    condition = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1980
    error_message = "The external port must be 0 - 65535."
  }
  validation {
  # Add max/min funcs and spread operator as variable is a list
  condition = max(var.ext_port["prod"]...) < 1980 && min(var.ext_port["prod"]...) >= 1880
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

# Change to a lookup so we can be returned appropriate list
locals {
  # Number of items in ext_port list
  container_count = length(var.ext_port[terraform.workspace])
}
