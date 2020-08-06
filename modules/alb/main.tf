# ------------------------------------------------------------------------------
# ALB
# ------------------------------------------------------------------------------

resource "aws_lb" "_" {
  name               = "${var.namespace}-${var.environment}-mule-${local.alb_type}-alb"
  internal           = var.internal

  load_balancer_type = "application"
  subnets            = var.subnets
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group._.id]

  enable_deletion_protection = local.enable_deletion_protection

  tags      = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-mule-${local.alb_type}-alb",
        "Service", "Application Load Balancing"
    )
  )
}

# ------------------------------------------------------------------------------
# --- Listener
# ------------------------------------------------------------------------------

resource "aws_lb_listener" "_" {
  load_balancer_arn = aws_lb._.arn

  port            = "443"
  protocol        = "HTTPS"
  ssl_policy      = var.tls_ssl_policy
  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group._.arn
    type             = "forward"
  }
}

# ------------------------------------------------------------------------------
# --- Target
# ------------------------------------------------------------------------------

resource "aws_lb_target_group" "_" {
  name                 = "${var.namespace}-${var.environment}-mule-${local.alb_type}-alb-tg"
  port                 = var.mule_exp_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "instance"
  deregistration_delay = var.deregistration_delay

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    path                = "/mule/healthcheck/applications/${var.mule_health_check_application_name}/ready"
    port                = var.health_check_port
  }

  tags = var.tags

  depends_on = [
    aws_lb._,
  ]
}

# ------------------------------------------------------------------------------
# --- Target Attachment
# ------------------------------------------------------------------------------

resource "aws_lb_target_group_attachment" "_" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group._.arn
  target_id        = var.target_instances[count.index]
  port             = var.mule_exp_port
}
