# ------------------------------------------------------------------------------
# CloudWatch
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# --- CloudWatch Log Group
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "_" {
  name              = "/${var.namespace}/${var.environment}/${var.app}"
  retention_in_days = var.log_retention_in_days

  tags                = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-${var.app}"
    )
  )
}

# ------------------------------------------------------------------------------
# CloudWatch Alarms
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# --- Restart unresponsive instance
# ------------------------------------------------------------------------------

resource "null_resource" "check_alarm_action" {
  count = var.instance_count

  triggers = {
    action = "arn:${data.aws_partition.default.partition}:swf:${local.region}:${data.aws_caller_identity.default.account_id}:${var.default_alarm_action}"
  }
}

resource "aws_cloudwatch_metric_alarm" "health" {
  count               = var.instance_count
  alarm_name          = "${var.namespace}-${var.environment}-${var.app}-${format("%02d", (count.index + 1))}-ec2-instance-running-state"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "StatusCheckFailed"
  namespace           = var.metric_namespace
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  depends_on          = [null_resource.check_alarm_action]

  dimensions = {
    InstanceId = aws_instance._[count.index].id
  }

  alarm_actions = [
    null_resource.check_alarm_action[count.index].triggers.action
  ]

  tags                = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-${var.app}-${format("%02d", (count.index + 1))}"
    )
  )
}

# ------------------------------------------------------------------------------
# --- CPU Usage
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "cpu" {
  count               = var.instance_count
  alarm_name          = "${var.namespace}-${var.environment}-${var.app}-${format("%02d", (count.index + 1))}-ec2-instance-cpu-state"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = var.metric_namespace
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    InstanceId = aws_instance._[count.index].id
  }

  tags                = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-${var.app}-${format("%02d", (count.index + 1))}"
    )
  )
}

# ------------------------------------------------------------------------------
# --- CPU Credits
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# --- Memory Usage
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "memory" {
  count               = var.instance_count
  alarm_name          = "${var.namespace}-${var.environment}-${var.app}-${format("%02d", (count.index + 1))}-ec2-instance-memory-state"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "mem_used_percent"
  namespace           = var.custom_metric_namespace
  period              = "60"
  statistic           = "Average"
  threshold           = var.mem_used_metric_percent

  dimensions = {
    InstanceId = aws_instance._[count.index].id
  }

  tags                = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-${var.app}-${format("%02d", (count.index + 1))}"
    )
  )
}

# ------------------------------------------------------------------------------
# --- Disk Usage
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "disk" {
  count               = var.instance_count
  alarm_name          = "${var.namespace}-${var.environment}-${var.app}-${format("%02d", (count.index + 1))}-ec2-instance-disk-state"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "disk_used_percent"
  namespace           = var.custom_metric_namespace
  period              = "60"
  statistic           = "Average"
  threshold           = var.disk_used_metric_percent

  dimensions = {
    InstanceId  = aws_instance._[count.index].id,
    fstype      = "ext4",
    path        ="/"
  }

  tags                = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-${var.app}-${format("%02d", (count.index + 1))}"
    )
  )
}
