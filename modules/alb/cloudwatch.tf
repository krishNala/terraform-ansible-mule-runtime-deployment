# ------------------------------------------------------------------------------
# CloudWatch
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = "${var.namespace}-${var.environment}-${var.app}-host-health"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = "60"
  statistic           = "Average"
  threshold           = var.instance_count
  alarm_description   = "Number of healthy nodes in Target Group"
  actions_enabled     = "true"
  dimensions = {
    TargetGroup  = aws_lb_target_group._.arn_suffix
    LoadBalancer = aws_lb._.arn_suffix
  }

  tags                = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-${var.app}-host-health"
    )
  )
}
