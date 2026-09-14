terraform {
  source = "../..//modules/vervium-cloud-ai"
}

inputs = {
  environment_name = "stage"
  cidr_block       = "10.0.0.0/16"
}

# A workaround for some issues I hit with Terragrunt and iCloud
download_dir = "/tmp/terragrunt-cache"