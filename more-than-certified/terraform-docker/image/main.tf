# Define docker image resource called container_image as we have multiple types
resource "docker_image" "container_image" {
  # Use variable from root main.tf
  name = var.image_in
}
