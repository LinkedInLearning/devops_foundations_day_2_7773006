module "asg" {
  source = "../../modules/vervium-asg"

  name          = "vervium-cloud-ai"
  instance_type = "t3.micro"

  # TODO: fill in your own AMI ID below!
  ami = "ami-08767ce8f5b17b5c7"

  # TODO: fill in your own Key Pair name below!
  key_name = "jim-brikman-personal-mgmt-us-east-2"

  min_instances = 2
  max_instances = 5

  vpc_id           = data.aws_vpc.default.id
  subnet_ids       = data.aws_subnets.default.ids
  target_group_arn = module.alb.target_group_arn
}

module "alb" {
  source = "../../modules/vervium-alb"

  name       = "vervium-cloud-ai"
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids
}

module "availability_monitoring" {
  source = "../../modules/availability-monitoring"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  name = "vervium-cloud-ai"

  app_url = {
    scheme = "http"
    host   = module.alb.domain_name
    port   = 80
    path   = "/"
  }

  # TODO: fill in your own email addresses
  alerts_email_addresses = ["jim+devops-foundations-test-1@gruntwork.io"]
}

module "dashboard" {
  source = "../../modules/cloudwatch-dashboard"

  name             = "vervium-cloud-ai"
  alb_arn          = module.alb.alb_arn
  target_group_arn = module.alb.target_group_arn
  asg_name         = module.asg.asg_name
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}