# ---------------------------------------------------------------------------------------------------------------------
# THE BASE VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PUBLIC SUBNETS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "public" {
  count             = length(data.aws_availability_zones.all.names)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 5, count.index)
  availability_zone = data.aws_availability_zones.all.names[count.index]

  # We set this to false, even in our public subnets, so that, by default, resources in that subnet don't get a public
  # IP (which is a more secure default). That said, this only changes the default. Any resources that needs a public IP
  # can still explicitly request one. For example, the aws_instance resource can set associate_public_ip_address = true.
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-public"
  }

  # Since we use separate aws_route resources, the aws_route_table resource will pick up a spurious diff when you run
  # 'plan' on its route attribute. This ignores the route attribute to avoid those spurious diffs.
  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_route_table_association" "public" {
  count          = length(data.aws_availability_zones.all.names)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc.id
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.name
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PRIVATE SUBNETS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "private" {
  count                   = length(data.aws_availability_zones.all.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 5, count.index + 10)
  availability_zone       = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-private"
  }

  # Since we use separate aws_route resources, the aws_route_table resource will pick up a spurious diff when you run
  # 'plan' on its route attribute. This ignores the route attribute to avoid those spurious diffs.
  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_route_table_association" "private" {
  count          = length(data.aws_availability_zones.all.names)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# ---------------------------------------------------------------------------------------------------------------------
# INTERFACE ENDPOINTS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  interface_vpc_endpoint_services = toset(var.vpc_endpoint_services)
}

resource "aws_security_group" "interface_vpc_endpoints" {
  count = length(local.interface_vpc_endpoint_services) > 0 ? 1 : 0

  name        = "${var.name}-interface-vpc-endpoints"
  description = "Security group for interface VPC endpoints in ${var.name}"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-interface-vpc-endpoints"
  }
}

resource "aws_vpc_security_group_ingress_rule" "interface_vpc_endpoints_https" {
  count = length(local.interface_vpc_endpoint_services) > 0 ? 1 : 0

  security_group_id = aws_security_group.interface_vpc_endpoints[0].id
  cidr_ipv4         = var.cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_endpoint" "interface" {
  for_each = local.interface_vpc_endpoint_services

  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.vpc_endpoint_services_multi_az ? aws_subnet.private[*].id : [aws_subnet.private[0].id]
  security_group_ids  = [aws_security_group.interface_vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = {
    Name = "${var.name}-${replace(each.value, ".", "-")}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DATA SOURCES
# ---------------------------------------------------------------------------------------------------------------------

data "aws_region" "current" {}
data "aws_availability_zones" "all" {}