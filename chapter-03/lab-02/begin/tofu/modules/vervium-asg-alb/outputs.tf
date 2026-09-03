output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.app.dns_name
}

output "iam_role_name" {
  description = "The name of the IAM role attached to the EC2 instances in the ASG"
  value       = aws_iam_role.app.name
}

output "asg_name" {
  description = "The name of the ASG"
  value       = aws_autoscaling_group.app.name
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.app.arn
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.app.arn
}

output "app_sg_id" {
  description = "The ID of the app's security group"
  value       = aws_security_group.app.id
}

output "alb_sg_id" {
  description = "The ID of the ALBs's security group"
  value       = aws_security_group.alb.id
}