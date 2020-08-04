# ------------------------------------------------------------------------------
# KMS
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# --- EBS Volume Key & Alias
# ------------------------------------------------------------------------------

resource "aws_kms_key" "ebs" {
  description             = "EBS Volume Key for ${var.app} in ${var.environment}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags              = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-${var.app}-ebs-ec2-instance-kms",
        "Service", "kms"
    )
  )
}

resource "aws_kms_alias" "ebs" {
  name          = "alias/${var.namespace}-${var.environment}-${var.app}-ebs-ec2-instance"
  target_key_id = aws_kms_key.ebs.key_id
}
