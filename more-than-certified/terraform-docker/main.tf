
# reference docker image resource from image module
module "nodered_image" {
  source = "./image"
  # Use key of image map to get image
  image_in = var.image["nodered"][terraform.workspace]
}

# 2nd image for DB
module "influxdb_image" {
  source = "./image"
  # Use key of image map to get image
  image_in = var.image["influxdb"][terraform.workspace]
}

module "container" {
  source = "./container"
  # Count kept in root as we don't want multiple containers within module
  count = local.container_count
  # Pass into module
  name_in = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  # Reference output from image module - We don't want module to module flow
  image_in = module.nodered_image.image_out
  # Ports - Inside module block as this info defined in root
  int_port_in = var.int_port
  ext_port_in = var.ext_port[terraform.workspace][count.index]
  # Volume
  container_path_in = "/data"
  
}
# Define random string resources for names of containers
resource "random_string" "random" {
  # Length of ext_port list
  count = local.container_count
  length = 4
  special = false
  upper = false
}
