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

resource "docker_image" "grafana_image" {
  # Name of image itself from DockerHub
  # Use map key instead of 
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana_container" {

  name = "grafana_container-${count.index}"
  # Specify docker image and ref image we made above
  # .latest gives us ID of the image
  image = docker_image.grafana_image.latest
  count = 2

}

output "public_ip" {
  value = [for x in docker_container.grafana_container : "${x.name} - ${x.ip_address}"]
}
