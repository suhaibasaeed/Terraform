locals {
  deployment = {
    nodered = {
      image = var.image["nodered"][terraform.workspace]
      int = 1880
      # Get from tfvars file map
      ext = var.ext_port["nodered"][terraform.workspace]
      container_path = "/data"
      
    }
    influxdb = {
      image = var.image["influxdb"][terraform.workspace]
      int = 8086
      # Get from tfvars file map
      ext = var.ext_port["influxdb"][terraform.workspace]
      container_path = "/var/lib/influxdb"
  }
}
}

# reference docker image resource from image module
module "image" {
  source = "./image"
  # for each argument passing in deployment map above
  for_each = local.deployment
  # Refer to value of deployment map and image key
  image_in = each.value.image
}

module "container" {
  source = "./container"
  # Add for_each and reference deployment map
  for_each = local.deployment
  # Pass into module
  name_in = join("-", [each.key, terraform.workspace, random_string.random[each.key].result])
  # Reference output from image module - We don't want module to module flow
  image_in = module.image[each.key].image_out
  # Ports - Inside module block as this info defined in root
  int_port_in = each.value.int
  # Because ext_port is a list and we only have one container being created for each
  ext_port_in = each.value.ext[0]
  # Volume
  container_path_in = each.value.container_path
  
}
# Define random string resources for names of containers
resource "random_string" "random" {
  # Use above map to find out how many we need
  for_each = local.deployment
  length = 4
  special = false
  upper = false
}
