# Define docker container resource
resource "docker_container" "nodered_container" {
  # Give it logical name if we need to reference it later
  name = var.name_in
  # Specify docker image and ref image we made above
  # Reference output from image module
  image = var.image_in
  # Ports to expose on container + mapping
  ports {
    # Pull in from root
    internal = var.int_port_in
    external = var.ext_port_in
  }
  # To mount folder to container
  volumes {
    # Nodered docs says mount it to data voluem in container
    container_path = var.container_path_in
    # Reference docker_volume resource's name below
    volume_name = docker_volume.container_volume.name
  }
}

resource "docker_volume" "container_volume" {
    name = "${var.name_in}-volume"
    lifecycle {
      prevent_destroy = false
    }
}
