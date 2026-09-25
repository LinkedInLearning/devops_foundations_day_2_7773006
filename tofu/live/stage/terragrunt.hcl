terraform {
  source = "../..//modules/vervium-cloud-ai"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  environment_name = "stage"
  cidr_block       = "10.0.0.0/16"
}