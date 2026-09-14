terraform {
  source = "../..//modules/vervium-cloud-ai"
}

inputs = {
  environment_name = "prod"
  cidr_block       = "10.1.0.0/16"

  # TODO: fill in your own domain name!
  custom_domain_name = {
    apex_domain = "devops-foundations.com"
    subdomain   = "www"
  }
}

# A workaround for some issues I hit with Terragrunt and iCloud
download_dir = "/tmp/terragrunt-cache"