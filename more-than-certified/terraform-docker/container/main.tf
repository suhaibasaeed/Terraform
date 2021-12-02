# Define docker container resource
resource "docker_container" "app_container" {
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
  dynamic "volumes" {
    for_each = var.volumes_in
    # Put settings in content block
    content {
    # Nodered docs says mount it to data volume in container
    container_path = volumes.value["container_path_each"]
    # Reference module for name
    volume_name = module.volume[count.index].volume_output[volumes.key]
    }
  }
  # Provisioner to create file
  provisioner "local-exec" {
    command = "echo ${self.name}: ${self.ip_address}:${join("", [for x in self.ports[*]["external"]: x])} >> containers.txt"
  }
  # Provisioner to destroy file
  provisioner "local-exec" {
    when = destroy
    command = "rm -f containers.txt"
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

# volume nested module within container module
module "volume" {
  source = "./volume"
  # Run module same amount of times container module run
  count = var.count_in
  # How many volumes created each time module run
  volume_count = length(var.volumes_in)
  volume_name = "${var.name_in}-${terraform.workspace}-${random_string.random[count.index].result}-volume"
}