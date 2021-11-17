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
  name = "nodered/node-red:latest"
}

# Define random string resources for names of containers
resource "random_string" "random" {
  count = var.container_count
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
  # To mount folder to container
  volumes {
    # Nodered docs says mount it to data voluem in container
    container_path = "/data"
    # Absolute host path
    host_path = "/home/ubuntu/environment/git_repo/Terraform/more-than-certified/terraform-docker/noderedvol"
  }
}
