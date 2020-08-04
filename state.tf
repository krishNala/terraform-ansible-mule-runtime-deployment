# ------------------------------------------------------------------------------
# Provider Settings
# ------------------------------------------------------------------------------

provider "aws" {
  region  = var.aws_region
  version = "~> 2.70.0"

  assume_role {
    role_arn = local.tf_deploy_arn
  }
}

# ------------------------------------------------------------------------------
# State Configuration
# ------------------------------------------------------------------------------

# configuration to apply the remote state management
terraform {
  backend "s3" {
    bucket    = "<CHANGE TO YOUR S3 BUCKET>"
    key       = "<CHANGE TO YOUR S3 BUCKET KEY>"
    region    = "<CHANGE TO YOUR REGION>"
    role_arn  = "<CHANGE TO YOUR ROLE ARN>"
  }
}
