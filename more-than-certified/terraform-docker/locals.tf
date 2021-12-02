locals {
  deployment = {
    # nodered = {
    #   container_count = length(var.ext_port["nodered"][terraform.workspace])
    #   image = var.image["nodered"][terraform.workspace]
    #   int = 1880
    #   # Get from tfvars file map
    #   ext = var.ext_port["nodered"][terraform.workspace]
    #   container_path = "/data"
      
    # }
    # influxdb = {
    #   container_count = length(var.ext_port["influxdb"][terraform.workspace])
    #   image = var.image["influxdb"][terraform.workspace]
    #   int = 8086
    #   # Get from tfvars file map
    #   ext = var.ext_port["influxdb"][terraform.workspace]
    #   container_path = "/var/lib/influxdb"
    # }
    grafana = {
      container_count = length(var.ext_port["grafana"][terraform.workspace])
      image = var.image["grafana"][terraform.workspace]
      # Interal port that grafana exposes
      int = 3000
      # Get from tfvars file map
      ext = var.ext_port["grafana"][terraform.workspace]
      # Iterate through volumes and create one for each one listed
      volumes = [
        {container_path_each = "/var/lib/grafana"},
        {container_path_each = "/etc/grafana" }
      ]
  }
}
}