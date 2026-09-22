terraform {
  source = "../..//modules/vervium-cloud-ai"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  environment_name = "prod"
  cidr_block       = "10.1.0.0/16"

  # TODO: fill in your own domain name!
  custom_domain_name = {
    apex_domain = "REPLACE_ME"
    subdomain   = "www"
  }
}