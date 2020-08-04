# ------------------------------------------------------------------------------
# IAM
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# --- Instance IAM Policy
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "_" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

# ------------------------------------------------------------------------------
# --- Instance IAM Permission Boundary
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "permissions_boundary" {
  statement {
    sid = ""

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["${aws_cloudwatch_log_group._.arn}"]

    effect = "Allow"
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeTags",
      "cloudwatch:PutMetricData",
    ]

    resources = ["*"]
  }
}

# ------------------------------------------------------------------------------
# --- IAM Role & Policy
# ------------------------------------------------------------------------------

resource "aws_iam_role" "_" {
  name                 = "${var.namespace}-${var.environment}-${var.app}-instance-role"
  path                 = "/"
  assume_role_policy   = data.aws_iam_policy_document._.json
}

resource "aws_iam_policy" "permissions_boundary" {
  name        = "${var.namespace}-${var.environment}-${var.app}-instance-permissions-boundary"
  path        = "/"
  description = "Mule EC2 instance permission boundary policy"

  policy = data.aws_iam_policy_document.permissions_boundary.json
}

resource "aws_iam_role_policy_attachment" "permissions_boundary" {
  role       = aws_iam_role._.name
  policy_arn = aws_iam_policy.permissions_boundary.arn
}

# ------------------------------------------------------------------------------
# --- Instance Profile
# ------------------------------------------------------------------------------

resource "aws_iam_instance_profile" "_" {
  name  = "${var.namespace}-${var.environment}-${var.app}-instance-profile"
  role  = aws_iam_role._.name
}
