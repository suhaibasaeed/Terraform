# Define docker image resource called nodered_image
resource "docker_image" "nodered_image" {
  # Use variable from root main.tf
  name = var.image_in
}
