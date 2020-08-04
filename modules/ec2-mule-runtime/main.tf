# ------------------------------------------------------------------------------
# EC2 Instance
# ------------------------------------------------------------------------------

resource "aws_instance" "_" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnets[count.index]
  iam_instance_profile        = aws_iam_instance_profile._.name
  monitoring                  = "true"
  source_dest_check           = "true"
  key_name                    = var.ssh_keypair

  disable_api_termination     = local.enable_deletion_protection

  vpc_security_group_ids      = [aws_security_group._.id]

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = false
    encrypted             = true
    kms_key_id            = aws_kms_key.ebs.id
  }

  lifecycle {
    ignore_changes = [root_block_device]
  }

  tags                    = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-${var.app}-${format("%02d", (count.index + 1))}"
    )
  )

  volume_tags             = merge(
    var.tags,
    map(
        "Name", "${var.namespace}-${var.environment}-${var.app}-${format("%02d", (count.index + 1))}"
    )
  )
}
