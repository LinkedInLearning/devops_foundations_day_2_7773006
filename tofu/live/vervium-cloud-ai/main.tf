module "vervium_cloud_ai" {
  source = "../../modules/vervium-ec2"

  name          = "vervium-cloud-ai"
  instance_type = "t3.micro"

  # TODO: fill in your own AMI ID below!
  ami = "REPLACE_ME"

  # TODO: fill in your own Key Pair name below!
  key_name = "REPLACE_ME"
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
    ip     = module.vervium_cloud_ai.ip
    port   = 8080
    path   = "/"
  }

  # TODO: fill in your own email addresses
  alerts_email_addresses = ["REPLACE_ME"]
}