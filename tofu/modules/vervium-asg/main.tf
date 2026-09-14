# ---------------------------------------------------------------------------------------------------------------------
# LAUNCH TEMPLATE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_launch_template" "app" {
  name                   = var.name
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name

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
  vpc_zone_identifier = var.subnet_ids

  health_check_type = "ELB"
  target_group_arns = [var.target_group_arn]

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

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "app" {
  name   = var.name
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "http_app" {
  security_group_id = aws_security_group.app.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ssh_app" {
  count             = var.key_name == null ? 0 : 1
  security_group_id = aws_security_group.app.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "all_app" {
  security_group_id = aws_security_group.app.id
  ip_protocol       = "all"
  cidr_ipv4         = "0.0.0.0/0"
}