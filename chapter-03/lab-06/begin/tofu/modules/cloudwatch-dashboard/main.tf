# ---------------------------------------------------------------------------------------------------------------------
# CLOUDWATCH DASHBOARD
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_dashboard" "app" {
  dashboard_name = var.name

  dashboard_body = jsonencode({
    widgets = local.all_widgets
  })
}

data "aws_region" "current" {}

# ---------------------------------------------------------------------------------------------------------------------
# WIDGET DEFINITIONS FOR THE CLOUDWATCH DASHBOARD
# ---------------------------------------------------------------------------------------------------------------------

locals {
  alb_dimension          = trimprefix(split(":", var.alb_arn)[5], "loadbalancer/")
  target_group_dimension = split(":", var.target_group_arn)[5]
  asg_dimension          = var.asg_name

  all_widgets = [
    {
      type   = "metric"
      x      = 0
      y      = 0
      width  = 12
      height = 6
      properties = {
        title   = "ALB Requests (Traffic)"
        region  = data.aws_region.current.region
        stat    = "Sum"
        view    = "timeSeries"
        stacked = false
        metrics = [
          ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", local.alb_dimension, { label = "traffic" }]
        ]
      }
    },
    {
      type   = "metric"
      x      = 12
      y      = 0
      width  = 12
      height = 6
      properties = {
        title   = "Target Group Response Time (Latency)"
        region  = data.aws_region.current.region
        stat    = "Average"
        view    = "timeSeries"
        stacked = false
        metrics = [
          ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", local.alb_dimension, "TargetGroup", local.target_group_dimension, { label = "latency" }]
        ]
      }
    },
    {
      type   = "metric"
      x      = 0
      y      = 6
      width  = 12
      height = 6
      properties = {
        title   = "Problematic Response Codes (Errors)"
        region  = data.aws_region.current.region
        stat    = "Sum"
        view    = "timeSeries"
        stacked = false
        metrics = [
          ["AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", "LoadBalancer", local.alb_dimension, "TargetGroup", local.target_group_dimension, { label = "4xx (Client Errors)" }],
          ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", local.alb_dimension, "TargetGroup", local.target_group_dimension, { label = "5xx (Server Errors)" }]
        ]
      }
    },
    {
      type   = "metric"
      x      = 12
      y      = 6
      width  = 12
      height = 6
      properties = {
        title   = "Server Health (Saturation)"
        region  = data.aws_region.current.region
        stat    = "Average"
        view    = "timeSeries"
        stacked = false
        metrics = [
          ["CWAgent", "cpu_usage_user", "AutoScalingGroupName", local.asg_dimension, { label = "CPU usage" }],
          ["CWAgent", "disk_used_percent", "AutoScalingGroupName", local.asg_dimension, { label = "disk usage" }],
          ["CWAgent", "mem_used_percent", "AutoScalingGroupName", local.asg_dimension, { label = "memory usage" }]
        ]
      }
    }
  ]
}
