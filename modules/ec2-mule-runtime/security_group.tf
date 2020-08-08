# ------------------------------------------------------------------------------
# EC2 Instance Security Group
# ------------------------------------------------------------------------------

resource "aws_security_group" "_" {
  name        = "${var.namespace}-${var.environment}-${var.app}-ec2-instance"
  vpc_id      = var.vpc_id
  description = "Instance default security group for Mule runtimes in ${var.environment}"
  tags        = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-${var.app}-ec2-instance"
    )
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "dev_access" {
  count                      = local.enable_dev_access == 1 ? length(compact(var.sg_ec2_ports)) : 0
  type                       = "ingress"
  from_port                  = var.sg_ec2_ports[count.index]
  to_port                    = var.sg_ec2_ports[count.index]
  protocol                   = "tcp"
  cidr_blocks                = var.developer_ingress_src
  security_group_id          = aws_security_group._.id
}

resource "aws_security_group_rule" "mgmt_access" {
  type                       = "ingress"
  from_port                  = 22
  to_port                    = 22
  protocol                   = "tcp"
  cidr_blocks                = var.mgmt_ingress_src
  security_group_id          = aws_security_group._.id
}

resource "aws_security_group_rule" "alb_access" {
  type                       = "ingress"
  from_port                  = var.mule_exp_port
  to_port                    = var.mule_exp_port
  protocol                   = "tcp"
  source_security_group_id   = var.alb_security_group_src
  security_group_id          = aws_security_group._.id
}

resource "aws_security_group_rule" "health_check_access" {
  type                       = "ingress"
  from_port                  = var.mule_agent_port
  to_port                    = var.mule_agent_port
  protocol                   = "tcp"
  source_security_group_id   = var.alb_security_group_src
  security_group_id          = aws_security_group._.id
}

resource "aws_security_group_rule" "egress" {
  count                      = local.enable_egress_traffic == 1 ? length(compact(var.sg_ec2_egress_ports)) : 0
  type                       = "egress"
  from_port                  = var.sg_ec2_egress_ports[count.index]
  to_port                    = var.sg_ec2_egress_ports[count.index]
  protocol                   = "tcp"
  cidr_blocks                = var.default_sg_egress_dst
  security_group_id          = aws_security_group._.id
}

resource "aws_security_group_rule" "ntp_egress" {
  type                       = "egress"
  from_port                  = var.sg_ec2_egress_ntp
  to_port                    = var.sg_ec2_egress_ntp
  protocol                   = "udp"
  cidr_blocks                = var.sg_ec2_egress_ntp_dst
  security_group_id          = aws_security_group._.id
}
