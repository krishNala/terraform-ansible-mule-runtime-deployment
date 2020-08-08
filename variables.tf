# ------------------------------------------------------------------------------
# Generic Variables
# ------------------------------------------------------------------------------

variable "environment" {
  type                  = string
  description           = "The environment the deployment is running in, dev,uat,preprod or prod."
}

variable "aws_region" {
  type                  = string
  description           = "The AWS region to deploy into (default: eu-west-2)."
  default               = "eu-west-2"
}

variable "namespace" {
  type                  = string
  description           = "The namespace to be applied typically a prefix for naming convention"
  default               = ""
}

variable "app" {
  type                  = string
  description           = "The name of the app or service"
  default               = "mule-runtime"
}

variable "private_subnet_ids" {
  type                  = list(string)
  description           = "The subnets ids of the private zone"
}

variable "vpc_id" {
  type                  = string
  description           = "The VPC ID"
}

variable "certificate_arn" {
  type                  = string
  description           = "The ARN of the certificate to be applied to the load balancer"
}

# ------------------------------------------------------------------------------
# EC2 Variables
# ------------------------------------------------------------------------------

variable "ami" {
  type                  = string
  description           = "The AMI ID of the image to deploy."
  default               = "ami-0b79808e499cf3385"
}

variable "sg_ec2_ports" {
  type                  = list(number)
  description           = "The ports to expose on a security group for the ingress traffic"
}

variable "instance_type" {
  type                  = string
  description           = "The EC2 instance type to deploy"
}

variable "instance_count" {
  type                  = number
  description           = "The number EC2 instances to deploy"
}

variable "developer_ingress_src" {
  type        = list(string)
  description = "List of allowed ingress CIDR blocks for developer machines"
  default     = []
}

variable "mgmt_ingress_src" {
  type        = list(string)
  description = "List of allowed ingress CIDR blocks to be able to access the instances on port 22"
  default     = [""]
}

variable "default_sg_egress_dst" {
  type        = list(string)
  description = "List of allowed egress CIDR blocks"
  default     = ["0.0.0.0/0"]
}

variable "sg_ec2_egress_ports" {
  type                  = list(number)
  description           = "The ports to allow egress traffic from the security group"
  default               = [80,443]
}

variable "ssh_keypair" {
  type                  = string
  description           = "The ID of the ssh key pair to be associated with the instance"
}

variable "root_volume_type" {
  type                  = string
  description           = "The root volume type"
}

variable "root_volume_size" {
  type                  = number
  description           = "The root volume size in GBs"
}

# ------------------------------------------------------------------------------
# ALB Variables
# ------------------------------------------------------------------------------

variable "alb_sg_ingress_src" {
  type        = list(string)
  description = "List of allowed ingress CIDR blocks"
  default     = []
}

variable "alb_healthy_threshold" {
  type        = number
  description = "The number of checks before the instance is declared healthy."
  default     = 3
}

variable "alb_unhealthy_threshold" {
  type        = number
  description = "The number of checks before the instance is declared unhealthy."
  default     = 10
}

variable "alb_health_check_timeout" {
  type        = number
  description = "The length of time before the check times out"
  default     = 5
}

variable "alb_health_check_interval" {
  type        = number
  description = "The interval between checks"
  default     = 10
}

# ------------------------------------------------------------------------------
# CloudWatch Variables
# ------------------------------------------------------------------------------

variable "log_retention_in_days" {
  type                  = number
  description           = "The number of days to retain cloudwatch logs for"
  default               = 90
}

variable "custom_metric_namespace" {
  type                  = string
  description           = "The custom metric namespace for the environment"
}

# ------------------------------------------------------------------------------
# Mule Variables
# ------------------------------------------------------------------------------

variable "mule_version" {
  type                  = string
  description           = "The version of Mule to be configured"
}

variable "mule_region" {
  type                  = string
  description           = "The region of the Anypoint control plane to use"
}

variable "mule_exp_port" {
  type                  = number
  description           = "The port number of the experience api"
  default               = 8083
}

variable "mule_agent_port" {
  type                  = number
  description           = "The port number of the mule agent used to perform application health checks"
  default               = 9999
}

variable "mule_health_check_application_name" {
  type                  = string
  description           = "The application name which the load balancer will perform application health checks against"
  default               = ""
}

variable "mule_amc" {
  type                  = string
  description           = "The AMC command to register the instance in the Anypoint Control Plane"
}

variable "java_metaspace_initial" {
  type                  = string
  description           = "The initial memory to be applied to the metaspace, this is used to generate the ansible variable files"
}

variable "java_metaspace_max" {
  type                  = string
  description           = "The max memory to be applied to the metaspace, this is used to generate the ansible variable files"
}

variable "java_memory_max" {
  type                  = string
  description           = "The max memory to be applied to the jvm, this is used to generate the ansible variable files"
}

variable "java_memory_initial" {
  type                  = string
  description           = "The initial memory to be applied to the jvm, this is used to generate the ansible variable files"
}

variable "mule_app_suffix" {
  type                  = string
  description           = "The suffix applied to all mule app names deployed to a runtime, this is used to ingest the log files into CloudWatch"
  default               = "-api"
}
