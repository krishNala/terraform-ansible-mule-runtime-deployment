# ------------------------------------------------------------------------------
# Local Variables
# ------------------------------------------------------------------------------

locals {
  tf_deploy_arn = "<CHANGE TO YOUR TERRAFORM DEPLOYMENT ROLE ARN>"

  tags = {
    App                 = "mule"
    Account             = var.environment
    Service             = "runtime"
  }
}
