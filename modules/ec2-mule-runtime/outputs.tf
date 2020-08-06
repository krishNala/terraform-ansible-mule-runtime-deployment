# ------------------------------------------------------------------------------
# Module Outputs
# ------------------------------------------------------------------------------

output "security_group_id" {
  description = "ID on the AWS Security Group associated with the instance"
  value       = aws_security_group._.id
}

output "mule_runtime_instance_ids" {
  description = "List of IDs of instances"
  value       = aws_instance._.*.id
}

# ------------------------------------------------------------------------------
# Ansible Outputs
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# --- The Ansible Inventory file
# ------------------------------------------------------------------------------

resource "local_file" "hosts" {
 content = templatefile("${path.module}/templates/hosts.tmpl",
 {
  host       = aws_instance._.*.tags.Name,
  private-ip = aws_instance._.*.private_ip,
  private-id = aws_instance._.*.id,
  sshkey     = var.ssh_keypair
 }
 )
 filename = "ansible/hosts.ini"
}

# ------------------------------------------------------------------------------
# --- The Ansible Variable file
# ------------------------------------------------------------------------------

resource "local_file" "variables" {
 content = templatefile("${path.module}/templates/variables.tmpl",
 {
  log_group                 = aws_cloudwatch_log_group._.name,
  region                    = data.aws_region.default.name
  mule_version              = var.mule_version
  mule_amc                  = var.mule_amc
  mule_region               = var.mule_region
  java_memory_max           = var.java_memory_max
  java_memory_initial       = var.java_memory_initial
  java_metaspace_max        = var.java_metaspace_max
  java_metaspace_initial    = var.java_metaspace_initial
  mule_agent_port           = var.mule_agent_port
 }
 )
 filename = "ansible/vars/variables.yml"
}

# ------------------------------------------------------------------------------
# --- CloudWatch Agent Config
# ------------------------------------------------------------------------------

resource "local_file" "cwagent" {
 content = templatefile("${path.module}/templates/amazon-cloudwatch-agent-schema.json.tmpl",
 {
  log_group               = aws_cloudwatch_log_group._.name,
  region                  = data.aws_region.default.name
  custom_metric_namespace = var.custom_metric_namespace
 }
 )
 filename = "ansible/files/amazon-cloudwatch-agent-schema.json"
}

# ------------------------------------------------------------------------------
# --- Mule Service
# ------------------------------------------------------------------------------

resource "local_file" "mule_service" {
 content = templatefile("${path.module}/templates/mule.service.tmpl",
 {
  env                  = var.environment
 }
 )
 filename = "ansible/files/mule.service"
}
