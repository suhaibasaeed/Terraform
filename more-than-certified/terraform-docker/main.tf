locals {
  deployment = {
    nodered = {
      container_count = length(var.ext_port["nodered"][terraform.workspace])
      image = var.image["nodered"][terraform.workspace]
      int = 1880
      # Get from tfvars file map
      ext = var.ext_port["nodered"][terraform.workspace]
      container_path = "/data"
      
    }
    influxdb = {
      container_count = length(var.ext_port["influxdb"][terraform.workspace])
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
  # How many containers to deploy
  count_in = each.value.container_count
  # Pass into module - Do join in module main.tf as random resource is there
  name_in = each.key
  # Reference output from image module - We don't want module to module flow
  image_in = module.image[each.key].image_out
  # Ports - Inside module block as this info defined in root
  int_port_in = each.value.int
  ext_port_in = each.value.ext
  # Volume
  container_path_in = each.value.container_path
  
}

