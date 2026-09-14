# ---------------------------------------------------------------------------------------------------------------------
# APPLICATION LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb" "app" {
  name               = var.name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids
}

# ---------------------------------------------------------------------------------------------------------------------
# HTTP LISTENER
# Redirect everything to HTTPS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      protocol    = "HTTPS"
      port        = "443"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# HTTPS LISTENER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.custom_domain.arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  # Wait for the cert to be validated before using it
  depends_on = [aws_acm_certificate_validation.custom_domain]
}

# ---------------------------------------------------------------------------------------------------------------------
# TARGET GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb_target_group" "app" {
  name     = var.name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "alb" {
  name   = "${var.name}-alb"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "health_checks" {
  security_group_id            = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
  referenced_security_group_id = var.app_security_group_id
}

# ---------------------------------------------------------------------------------------------------------------------
# CUSTOM DOMAIN NAME
# ---------------------------------------------------------------------------------------------------------------------

data "aws_route53_zone" "app" {
  name = "${var.custom_domain_name.apex_domain}."
}

resource "aws_route53_record" "custom_domain_name" {
  zone_id = data.aws_route53_zone.app.zone_id
  name    = "${var.custom_domain_name.subdomain}.${var.custom_domain_name.apex_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# TLS CERTIFICATES FROM ACM FOR THE CUSTOM DOMAIN NAME
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_acm_certificate" "custom_domain" {
  domain_name       = aws_route53_record.custom_domain_name.name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "custom_domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.custom_domain.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.app.zone_id
}

resource "aws_acm_certificate_validation" "custom_domain" {
  certificate_arn         = aws_acm_certificate.custom_domain.arn
  validation_record_fqdns = [for key, validation in aws_route53_record.custom_domain_validation : validation.fqdn]
}