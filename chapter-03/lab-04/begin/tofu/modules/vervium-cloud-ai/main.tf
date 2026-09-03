module "vervium_cloud_ai" {
  source = "../../modules/vervium-asg-alb"

  name             = "vervium-cloud-ai-${var.environment_name}"
  instance_type    = "t3.micro"
  environment_name = var.environment_name

  # TODO: fill in your own AMI ID below!
  ami = "ami-004d5878b9a69f971"

  # TODO: fill in your own Key Pair name below!
  key_name = "jim-brikman-personal-mgmt-us-east-2"

  min_instances = 2
  max_instances = 5

  vpc_id         = module.vpc.vpc.id
  asg_subnet_ids = module.vpc.private_subnets[*].id
  alb_subnet_ids = module.vpc.public_subnets[*].id
}

module "vpc" {
  source = "../../modules/vpc"

  name       = var.environment_name
  cidr_block = var.cidr_block

  vpc_endpoint_services = [
    # Endpoints for CloudWatch Agent: logs for logging, monitoring for metrics, xray for traces, and ec2 to allow the
    # agent to fetch data from the EC2 APIs
    "logs",
    "monitoring",
    "xray",
    "ec2"
  ]
}

module "availability_monitoring" {
  source = "../../modules/availability-monitoring"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  name = "vervium-cloud-ai-${var.environment_name}"

  app_url = {
    scheme = "http"
    host   = module.vervium_cloud_ai.alb_dns_name
    port   = 80
    path   = "/"
  }

  # TODO: fill in your own email addresses
  alerts_email_addresses = ["jim+devops-foundations-test-1@gruntwork.io"]
}

module "dashboard" {
  source = "../../modules/cloudwatch-dashboard"

  name             = "vervium-cloud-ai-${var.environment_name}"
  alb_arn          = module.vervium_cloud_ai.alb_arn
  target_group_arn = module.vervium_cloud_ai.target_group_arn
  asg_name         = module.vervium_cloud_ai.asg_name
}