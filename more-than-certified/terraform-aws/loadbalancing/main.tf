# loadbalancing/main.tf

resource "aws_lb" "mtc_lb" {
    name = "mtcloadbalancer"
    # What AZs/subnets to route traffic to
    subnets = var.public_subnets
    # What traffic can reach it
    security_groups = [var.sublic_sg]
    idle_timeout = 400
}