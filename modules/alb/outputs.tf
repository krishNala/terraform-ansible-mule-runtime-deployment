output "alb_name" {
  description = "The ARN suffix of the ALB"
  value       = aws_lb._.name
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb._.arn
}

output "alb_dns_name" {
  description = "DNS name of ALB"
  value       = aws_lb._.dns_name
}

output "alb_zone_id" {
  description = "The ID of the zone which ALB is provisioned"
  value       = aws_lb._.zone_id
}

output "default_target_group_arn" {
  description = "The default target group ARN"
  value       = aws_lb_target_group._.arn
}

output "security_group_id" {
  description = "ID on the AWS Security Group associated with the instance"
  value       = aws_security_group._.id
}
