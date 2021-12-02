resource "docker_volume" "container_volume" {
    # Number of volumes passed in from locals deployment block
    count = var.volume_count
    name = "${var.volume_name}-${count.index}"
    lifecycle {
      prevent_destroy = false
    }
    # Create back up folder
    provisioner "local-exec" {
      # When we are destroying infrastructure
      when = destroy
      command = "mkdir ${path.cwd}/../backup"
      # We have 3 containers so it will try to create 3 times - failing twice
      on_failure = continue
    }
    # Do actual back up - create tar.gz file of volume (mountpoint)
    provisioner "local-exec" {
      when = destroy
      command = "sudo tar -czvf ${path.cwd}/../backup/${self.name}.tar.gz ${self.mountpoint}/"
      on_failure = fail
    }
}