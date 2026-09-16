output "plan_role_arn" {
  description = "The ARN of the plan IAM role"
  value       = aws_iam_role.plan.arn
}

output "apply_role_arn" {
  description = "The ARN of the apply IAM role"
  value       = aws_iam_role.apply.arn
}

output "packer_build_role_arn" {
  description = "The ARN of the packer build IAM role"
  value       = aws_iam_role.packer_build.arn
}