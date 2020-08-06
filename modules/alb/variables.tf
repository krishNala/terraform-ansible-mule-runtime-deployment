variable "namespace" {
  type        = string
  description = "Namespace"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  default     = ""
}

variable "app" {
  type        = string
  description = "Name of the application"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
  default     = {}
}

variable "internal" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether the ALB should be internal"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to associate with NLB"
}

variable "subnets" {
  type        = list(string)
  description = "A list of subnet IDs to associate with NLB"
}

variable "alb_sg_ingress_src" {
  type        = list(string)
  description = "List of allowed ingress CIDR blocks"
}

variable "ec2_security_group_id" {
  type        = string
  description = "The security group to allow access to from the load balancer"
}

variable "mule_exp_port" {
  type        = number
  description = "The port exposed for the Mulesoft Experience API"
}

variable "mule_health_check_application_name" {
  type                  = string
  description           = "The Mule application name to perform health checks against"
}

variable "tls_ssl_policy" {
  type        = string
  description = "The name of the SSL Policy for the listener"
  default     = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

variable "deregistration_delay" {
  type        = number
  default     = 15
  description = "The amount of time to wait in seconds before changing the state of a deregistering target to unused"
}

variable "health_check_port" {
  type        = number
  default     = 443
  description = "The port to send the health check request to (defaults to `traffic-port`)"
}

variable "health_check_protocol" {
  type        = string
  default     = "HTTP"
  description = "The protocol to use for the health check request"
}

variable "health_check_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy, or failures required before considering a health target unhealthy"
}

variable "health_check_interval" {
  type        = number
  description = "The duration in seconds in between health checks"
}

variable "health_check_timeout" {
  type        = number
  description = "The duration in seconds before the health check times out."
}

variable "healthy_threshold" {
  type        = number
  description = "The number of checks before the instance is declared healthy."
}

variable "unhealthy_threshold" {
  type        = number
  description = "The number of checks before the instance is declared unhealthy."
}

variable "certificate_arn" {
  type                  = string
  description           = "The ARN of the certificate to be applied to the load balancer"
}

variable "instance_count" {
  description = "The number of instances that have been provisioned"
  type        = number
}

variable "target_instances" {
  description = "The instance IDs of the provisioned runtimes"
  type        = list(string)
}
