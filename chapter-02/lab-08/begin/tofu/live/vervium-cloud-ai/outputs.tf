output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.vervium_cloud_ai.alb_dns_name
}

output "dashboard_url" {
  description = "The URL of the CloudWatch dashboard"
  value       = module.dashboard.dashboard_url
}