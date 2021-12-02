# Used by root module docker_container resource
output "image_out" {
    # Same because we're in same dir as image
    value = docker_image.container_image.latest
}