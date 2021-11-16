terraform {
  required_providers {
    # Alias which says any resource starting with Docker uses this provider
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.15.0"
    }
  }
}

# Instantiate provider
provider "docker" {}

# Add variables
variable "ext_port" {
  type = number
  default = 1880
}

variable "int_port" {
  type = number
  default = 1880
}

variable "container_count" {
  type = number
  default = 1
}

# Define docker image resource called nodered_image
resource "docker_image" "nodered_image" {
  # Name of image itself from DockerHub
  name = "nodered/node-red:latest"
}

# Define random string resources for names of containers
resource "random_string" "random" {
  count = 1
  length = 4
  special = false
  upper = false
}

# Define docker container resource
resource "docker_container" "nodered_container" {
  count = var.container_count # 1 container now only
  # Give it logical name if we need to reference it later - Use random string
  name = join("-", ["nodered", random_string.random[count.index].result])
  # Specify docker image and ref image we made above
  # .latest gives us ID of the image
  image = docker_image.nodered_image.latest
  # Ports to expose on container + mapping
  ports {
    internal = var.int_port
    external = var.ext_port
  }
}

# Add output values referencing attribute of above container
output "container_name" {
  value       = docker_container.nodered_container[*].name
  description = "Name of container"
}
# Use join function to output ipaddr:port with for loop
output "Ip_address_port" {
  value       = [for i in docker_container.nodered_container: join(":",[i.ip_address, i.ports[0].external])]
  description = "IP addr & port of container"
}

