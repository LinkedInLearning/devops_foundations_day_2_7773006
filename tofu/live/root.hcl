remote_state {
  backend = "local"
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

# A workaround for some issues I hit with Terragrunt and iCloud
download_dir = "/tmp/terragrunt-cache"