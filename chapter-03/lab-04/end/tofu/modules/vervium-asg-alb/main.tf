# ---------------------------------------------------------------------------------------------------------------------
# LAUNCH TEMPLATE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_launch_template" "app" {
  name                   = var.name
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {environment_name = var.environment_name}))

  iam_instance_profile {
    arn = aws_iam_instance_profile.app.arn
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "app" {
  name = var.name

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  max_size            = var.max_instances
  min_size            = var.min_instances
  vpc_zone_identifier = var.asg_subnet_ids

  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.app.arn]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      max_healthy_percentage = 200
      min_healthy_percentage = 100
      auto_rollback          = true
    }
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM INSTANCE PROFILE AND IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_instance_profile" "app" {
  name = var.name
  role = aws_iam_role.app.name
}

resource "aws_iam_role" "app" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM PERMISSIONS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role       = aws_iam_role.app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ---------------------------------------------------------------------------------------------------------------------
# APPLICATION LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lb" "app" {
  name               = var.name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.alb_subnet_ids
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

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
# SECURITY GROUP FOR THE EC2 INSTANCES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "app" {
  name   = var.name
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "http_app" {
  security_group_id            = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "app" {
  for_each                     = var.allow_asg_egress
  security_group_id            = aws_security_group.app.id
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  referenced_security_group_id = each.value.referenced_security_group_id
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUP FOR THE ALB
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "alb" {
  name   = "${var.name}-alb"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "http_alb" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_health_checks" {
  security_group_id            = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
  referenced_security_group_id = aws_security_group.app.id
}