output "iam_role_name" {
  description = "The name of the IAM role attached to the EC2 instances in the ASG"
  value       = aws_iam_role.app.name
}

output "asg_name" {
  description = "The name of the ASG"
  value       = aws_autoscaling_group.app.name
}

output "security_group_id" {
  description = "The ID of the app's security group"
  value       = aws_security_group.app.id
}