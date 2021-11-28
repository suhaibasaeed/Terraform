# Define docker image resource called nodered_image
resource "docker_image" "nodered_image" {
  # Name of image itself from DockerHub
  # Use map key instead of lookup
  name = "nodered/node-red:latest"
}