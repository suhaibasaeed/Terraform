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
    # Reference docker_volume resource's name below
    volume_name = docker_volume.container_volume[volumes.key].name
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

resource "docker_volume" "container_volume" {
    # Number of volumes passed in from locals deployment block
    count =length(var.volumes_in)
    name = "${var.name_in}-${count.index}-volume"
    lifecycle {
      prevent_destroy = false
    }
    # Create back up folder
    provisioner "local-exec" {
      # When we are destroying infrastructure
      when = destroy
      command = "mkdir ${path.cwd}/../backup"
      # We have 3 containers so it will try to create 3 times - failing twice
      on_failure = continue
    }
    # Do actual back up - create tar.gz file of volume (mountpoint)
    provisioner "local-exec" {
      when = destroy
      command = "sudo tar -czvf ${path.cwd}/../backup/${self.name}.tar.gz ${self.mountpoint}/"
      on_failure = fail
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