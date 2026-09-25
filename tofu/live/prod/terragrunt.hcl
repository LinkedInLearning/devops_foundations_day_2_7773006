terraform {
  source = "../..//modules/vervium-cloud-ai"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  environment_name = "prod"
  cidr_block       = "10.1.0.0/16"
}