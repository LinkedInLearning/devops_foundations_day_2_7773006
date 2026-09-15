terraform {
  source = "../..//modules/vervium-cloud-ai"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  environment_name = "stage"
  cidr_block       = "10.0.0.0/16"

  # TODO: fill in your own domain name!
  custom_domain_name = {
    apex_domain = "REPLACE_ME"
    subdomain   = "staging"
  }

  custom_tags = {
    Testing = "gitops-pipeline"
  }
}