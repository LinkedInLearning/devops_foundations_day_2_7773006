# ---------------------------------------------------------------------------------------------------------------------
# EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "vervium_cloud_ai" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.vervium_cloud_ai.id]
  key_name               = var.key_name

  tags = {
    Name = var.name
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "vervium_cloud_ai" {
  name = var.name
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.vervium_cloud_ai.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  count             = var.key_name == null ? 0 : 1
  security_group_id = aws_security_group.vervium_cloud_ai.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.vervium_cloud_ai.id
  ip_protocol       = "all"
  cidr_ipv4         = "0.0.0.0/0"
}