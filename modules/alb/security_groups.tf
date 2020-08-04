resource "aws_security_group" "_" {
  name        = "${var.namespace}-${var.environment}-mule-${local.alb_type}-alb"
  vpc_id      = var.vpc_id
  description = "Instance default security group for Mule load balancers"

  tags      = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-mule-${local.alb_type}-alb",
        "Service", "Application Load Balancing"
    )
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = var.default_sg_ingress_src
  security_group_id = aws_security_group._.id
}

resource "aws_security_group_rule" "egress" {
  type                      = "egress"
  from_port                 = var.mule_exp_port
  to_port                   = var.mule_exp_port
  protocol                  = "tcp"
  security_group_id         = aws_security_group._.id
  source_security_group_id  = var.ec2_security_group_id
}
