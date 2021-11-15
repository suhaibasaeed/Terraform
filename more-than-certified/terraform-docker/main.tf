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

# Define docker image resource called nodered_image
resource "docker_image" "nodered_image" {
  # Name of image itself from DockerHub
  name = "nodered/node-red:latest"
}

# Define random string resources for names of containers
resource "random_string" "random" {
  count = 2
  length = 4
  special = false
  upper = false
}

# Define docker container resource
resource "docker_container" "nodered_container" {
  count = 2 # 2 containers
  # Give it logical name if we need to reference it later - Use random string
  name = join("-", ["nodered", random_string.random[count.index].result])
  # Specify docker image and ref image we made above
  # .latest gives us ID of the image
  image = docker_image.nodered_image.latest
  # Ports to expose on container + mapping
  ports {
    internal = 1880
    #external = 1880
  }
}


# Add output values referencing attribute of above container
# Use join function to output ipaddr:port
output "Ip_address_port" {
  value       = join(":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external])
  description = "IP addr & port of container"
}

output "container_name" {
  value       = docker_container.nodered_container[0].name
  description = "Name of container"
}

output "Ip_address_port2" {
  value       = join(":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external])
  description = "IP addr & port of container"
}

output "container_name2" {
  value       = docker_container.nodered_container[1].name
  description = "Name of container"
}
