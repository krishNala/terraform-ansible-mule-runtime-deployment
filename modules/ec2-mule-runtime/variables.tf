variable "namespace" {
  type        = string
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  default     = ""
}

variable "app" {
  type        = string
  description = "Name  (e.g. `bastion` or `mule`)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to associate with NLB"
}

variable "ami" {
  type        = string
  description = "The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04"
  default     = ""
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "instance_count" {
  description = "The number of instances to provision"
  type        = number
}

variable "instance_type" {
  description = "The instances type to provision"
  type        = string
}

variable "subnets" {
  type        = list(string)
  description = "The subnets to deploy the instance too"
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(map(string))
  default     = []
}

variable "mgmt_ingress_src" {
  type        = list(string)
  description = "List of allowed ingress CIDR blocks"
}

variable "sg_ec2_ports" {
  type                  = list(number)
  description           = "The ports to expose on a security group for the ingress traffic"
}

variable "default_sg_egress_dst" {
  type        = list(string)
  description = "List of allowed egress CIDR blocks"
  default     = ["0.0.0.0/0"]
}

variable "sg_ec2_egress_ports" {
  type                  = list(number)
  description           = "The ports to expose from the security group for the egress traffic"
  default               = [443]
}

variable "default_alarm_action" {
  type        = string
  default     = "action/actions/AWS_EC2.InstanceId.Reboot/1.0"
  description = "Default alerm action"
}

variable "metric_namespace" {
  type        = string
  description = "The namespace for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-namespaces.html"
  default     = "AWS/EC2"
}

variable "log_retention_in_days" {
  type                  = number
  description           = "The number of days to retain cloudwatch logs for"
  default               = 90
}

variable "ssh_keypair" {
  type                  = string
  description           = "The ID of the ssh key pair to be associated with the instance"
}

variable "alb_security_group_src" {
  type                  = string
  description           = "The security group ID of the alb to allow access to the experience api port"
}

variable "mule_exp_port" {
  type        = number
  description = "The port exposed for the Mulesoft Experience API"
}

variable "mule_agent_port" {
  type                  = number
  description           = "The port number of the mule agent used to perform application health checks"
}

variable "developer_ingress_src" {
  type        = list(string)
  description = "List of allowed ingress CIDR blocks for developer machines"
  default     = []
}

variable "mem_used_metric_percent" {
  type        = number
  description = "The percentage of memory used to generate an alarm"
  default     = 80
}

variable "disk_used_metric_percent" {
  type        = number
  description = "The percentage of disk space used to generate an alarm"
  default     = 80
}

variable "custom_metric_namespace" {
  type                  = string
  description           = "The custom metric namespace for the environment"
}

variable "mule_version" {
  type                  = string
  description           = "The version of Mule to be configured"
}

variable "mule_region" {
  type                  = string
  description           = "The region of the Anypoint control plane to use"
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

variable "mule_amc" {
  type                  = string
  description           = "The AMC command to register the instance in the Anypoint Control Plane"
}

variable "root_volume_type" {
  type                  = string
  description           = "The root volume type"
}

variable "root_volume_size" {
  type                  = number
  description           = "The root volume size in GBs"
}
