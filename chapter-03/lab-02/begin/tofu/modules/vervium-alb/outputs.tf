output "domain_name" {
  description = "The domain name of the ALB"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.app.arn
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.app.arn
}

output "security_group_id" {
  description = "The ID of the ALBs's security group"
  value       = aws_security_group.alb.id
}