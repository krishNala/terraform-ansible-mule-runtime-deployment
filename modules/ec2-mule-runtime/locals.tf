# ------------------------------------------------------------------------------
# Local variables
# ------------------------------------------------------------------------------

locals {
  enable_dev_access           = length(var.developer_ingress_src) > 0 ? 1 : 0
  enable_egress_traffic       = length(var.sg_ec2_egress_ports) > 0 ? 1 : 0
  region                      = data.aws_region.default.name
  enable_deletion_protection  = var.environment == "prod" ? true : false

}

# ------------------------------------------------------------------------------
# Data Sources
# ------------------------------------------------------------------------------

data "aws_caller_identity" "default" {
}

data "aws_region" "default" {
}

data "aws_partition" "default" {
}
