# loadbalancing/main.tf

resource "aws_lb" "mtc_lb" {
  name = "mtcloadbalancer"
  # What AZs/subnets to route traffic to
  subnets = var.public_subnets
  # What traffic can reach it
  security_groups = [var.public_sg]
  idle_timeout    = 400
}

resource "aws_lb_target_group" "mtc_tg" {
  name     = "mtc-lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    # Ignore any changes to resource name
    ignore_changes = [name]
    # Ensure new target group created before old is destroyed
    create_before_destroy = true
  }
  health_check {
    healthy_threshold   = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }
}

resource "aws_lb_listener" "mtc_lb_listener" {
  load_balancer_arn = aws_lb.mtc_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    # Forward all traffic to target group
    type             = "forward"
    target_group_arn = aws_lb_target_group.mtc_tg.arn
  }
}
