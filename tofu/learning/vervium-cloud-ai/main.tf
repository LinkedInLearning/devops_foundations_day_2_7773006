# ---------------------------------------------------------------------------------------------------------------------
# EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "vervium_cloud_ai" {
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.vervium_cloud_ai.id]

  # TODO: fill in your own AMI ID below!
  ami = "ami-09f833cbef0620166"

  # TODO: fill in your own Key Pair name below!
  key_name = "jim-brikman-personal-mgmt-us-east-2"

  tags = {
    Name = "vervium-cloud-ai"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "vervium_cloud_ai" {
  name = "vervium-cloud-ai"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.vervium_cloud_ai.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
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