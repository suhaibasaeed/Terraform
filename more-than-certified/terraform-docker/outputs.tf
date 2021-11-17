# Add output values referencing attribute of above container
output "container_name" {
  value       = docker_container.nodered_container[*].name
  description = "Name of container"
}
# Use join function to output ipaddr:port with for loop
output "Ip_address_port" {
  value       = [for i in docker_container.nodered_container: join(":",[i.ip_address, i.ports[0].external])]
  description = "IP addr & port of container"
  sensitive = true
}