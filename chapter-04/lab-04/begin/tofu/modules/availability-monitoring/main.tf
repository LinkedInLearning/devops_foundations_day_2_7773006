# ---------------------------------------------------------------------------------------------------------------------
# ROUTE 53 HEALTH CHECK
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route53_health_check" "availability" {
  fqdn              = var.app_url.host
  ip_address        = var.app_url.ip
  type              = upper(var.app_url.scheme)
  port              = var.app_url.port
  resource_path     = var.app_url.path
  failure_threshold = 1
  request_interval  = 30

  tags = {
    Name = var.name
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CLOUDWATCH ALARM FOR ROUTE 53 HEALTH CHECK
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "app_is_down" {
  # Route 53 Health Check Metrics only live in us-east-1, so create all the alert-related resources in that region
  provider = aws.us_east_1

  alarm_name = "${var.name}-is-down"

  namespace   = "AWS/Route53"
  metric_name = "HealthCheckStatus"
  dimensions = {
    HealthCheckId = aws_route53_health_check.availability.id
  }

  statistic           = "Minimum"
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  period              = 60
  evaluation_periods  = 1
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.cloudwatch_alerts.arn]
}

# ---------------------------------------------------------------------------------------------------------------------
# SNS TOPIC AND SUBSCRIPTIONS FOR ALERTS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_sns_topic" "cloudwatch_alerts" {
  # Route 53 Health Check Metrics only live in us-east-1, so create all the alert-related resources in that region
  provider = aws.us_east_1
  name     = "${var.name}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  # Route 53 Health Check Metrics only live in us-east-1, so create all the alert-related resources in that region
  provider  = aws.us_east_1
  for_each  = var.alerts_email_addresses
  topic_arn = aws_sns_topic.cloudwatch_alerts.arn
  protocol  = "email"
  endpoint  = each.key
}
