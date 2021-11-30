# Reference module output value
output "container_name" {
  value       = module.container[*].container_name
  description = "Name of container"
  }
  
# Reference module output name
output "Ip_address_port" {
  value       = flatten(module.container[*].ip_address_port)
  description = "IP addr & port of container"
}
