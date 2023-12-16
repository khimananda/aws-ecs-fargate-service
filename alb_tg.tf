####################################
#--- ECS Service - Target Group ---#
####################################

resource "aws_lb_target_group" "this" {
  count                         = var.enable_public_endpoint == true ? 1 : 0
  name                          = "${var.name}-tg"
  port                          = var.container["APP_PORT"]
  protocol                      = var.protocol
  vpc_id                        = var.vpc_id
  target_type                   = "ip"
  load_balancing_algorithm_type = "least_outstanding_requests"

  health_check {
    interval = 60
    timeout  = 30
    protocol = var.protocol
    matcher  = var.matcher
    path     = var.health_check_path // required only for HTTP & HTTPS
  }

  tags = merge(
    var.tags,
    {
      Name   = "${var.name}-tg"
      Domain = var.domain
    }
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      name
    ]
  }

  # depends_on = [null_resource.alb_listener_exists]
}


#####################################
#--- ECS Service - Listener Rule ---#
#####################################

resource "aws_alb_listener_rule" "this" {
  count        = var.enable_public_endpoint == true ? 1 : 0
  listener_arn = var.listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }

  condition {
    host_header {
      values = [var.domain]
    }
  }

  depends_on = [aws_lb_target_group.this]
}

