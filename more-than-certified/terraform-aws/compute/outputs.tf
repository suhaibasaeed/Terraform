# compute/outputs.tf

# Output everything
output "instance" {
  value = aws_instance.mtc_node[*]
}

output "port" {
  # Pull first port only as it's same for all instances
  value = aws_lb_target_group_attachment.mtc_tf_attach[0].port
}