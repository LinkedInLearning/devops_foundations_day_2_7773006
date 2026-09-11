output "domain_name" {
  description = "The domain name for this app"
  value       = module.vervium_cloud_ai.domain_name
}

output "dashboard_url" {
  description = "The URL of the CloudWatch dashboard"
  value       = module.dashboard.dashboard_url
}