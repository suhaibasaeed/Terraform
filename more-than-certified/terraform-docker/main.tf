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

# Create null resource for local exec provisioner
resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    # Bash command to create directory and mount to docker vol
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol"
  }
}

# Define docker image resource called nodered_image
resource "docker_image" "nodered_image" {
  # Name of image itself from DockerHub
  # Use lookup to pull from map based on what env variable is
  name = lookup(var.image, var.env)
}

# Define random string resources for names of containers
resource "random_string" "random" {
  # Length of ext_port list
  count = local.container_count
  length = 4
  special = false
  upper = false
}

# Define docker container resource
resource "docker_container" "nodered_container" {
  # length of ext_port list
  count = local.container_count
  # Give it logical name if we need to reference it later - Use random string
  name = join("-", ["nodered", random_string.random[count.index].result])
  # Specify docker image and ref image we made above
  # .latest gives us ID of the image
  image = docker_image.nodered_image.latest
  # Ports to expose on container + mapping
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }
  # To mount folder to container
  volumes {
    # Nodered docs says mount it to data voluem in container
    container_path = "/data"
    # Absolute host path using path.cwd named value and string interpolation
    host_path = "${path.cwd}/noderedvol"
  }
}
