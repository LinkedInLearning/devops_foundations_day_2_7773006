remote_state {
  backend = "s3"
  config = {
    # TODO: fill in your own S3 bucket name
    bucket       = "REPLACE_ME"
    key          = "tofu/live/${path_relative_to_include()}/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

# A workaround for some issues I hit with Terragrunt and iCloud
download_dir = "/tmp/terragrunt-cache"