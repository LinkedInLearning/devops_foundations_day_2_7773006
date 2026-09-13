output "domain_name" {
  description = "The domain name for the ALB"
  value       = module.alb.domain_name
}

output "dashboard_url" {
  description = "The URL of the CloudWatch dashboard"
  value       = module.dashboard.dashboard_url
}