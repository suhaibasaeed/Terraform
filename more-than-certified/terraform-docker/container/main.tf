# Define docker container resource
resource "docker_container" "nodered_container" {
  count = var.count_in
  # Give it logical name if we need to reference it later
  name = join("-", [var.name_in, terraform.workspace, random_string.random[count.index].result])
  # Specify docker image and ref image we made above
  # Reference output from image module
  image = var.image_in
  # Ports to expose on container + mapping
  ports {
    # Pull in from root - count index as it's a list
    internal = var.int_port_in
    external = var.ext_port_in[count.index]
  }
  # To mount folder to container
  volumes {
    # Nodered docs says mount it to data voluem in container
    container_path = var.container_path_in
    # Reference docker_volume resource's name below
    volume_name = docker_volume.container_volume[count.index].name
  }
}

resource "docker_volume" "container_volume" {
    count = var.count_in
    name = "${var.name_in}-${random_string.random[count.index].result}-volume"
    lifecycle {
      prevent_destroy = false
    }
}

# Define random string resources for names of containers
resource "random_string" "random" {
  # Use variable from root
  count = var.count_in
  length = 4
  special = false
  upper = false
}