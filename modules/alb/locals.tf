locals {
  alb_type                    = var.internal    == true ? "int" : "ext"
  enable_deletion_protection  = var.environment == "prod" ? true : false
}
