
# Create null resource for local exec provisioner
resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    # Bash command to create directory and mount to docker vol
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol"
  }
}

# reference docker image resource from image module
module "image" {
  source = "./image"
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
  name = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  # Specify docker image and ref image we made above
  # Reference output from image module
  image = module.image.image_out
  # Ports to expose on container + mapping
  ports {
    internal = var.int_port
    # Use map key ref instead of lookup
    external = var.ext_port[terraform.workspace][count.index]
  }
  # To mount folder to container
  volumes {
    # Nodered docs says mount it to data voluem in container
    container_path = "/data"
    # Absolute host path using path.cwd named value and string interpolation
    host_path = "${path.cwd}/noderedvol"
  }
}
