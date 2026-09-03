packer {
  # We need the AWS plugin to build AMIs
  required_plugins {
    amazon = {
      version = ">= 1.8.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Use a data source to automatically find the ID of the latest Ubuntu AMI. AWS releases new versions of this AMI on
# a regular basis, and it's important to get the latest version, as it has all the newest updates and security patches.
data "amazon-ami" "ubuntu" {
  filters = {
    name                = "ubuntu/images/hvm-ssd*/ubuntu-resolute-26.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS Account ID
  region      = "us-east-2"
}

# Start the build with the Ubuntu AMI as the source
source "amazon-ebs" "ubuntu" {
  ami_name        = "vervium-cloud-ai-${uuidv4()}"
  ami_description = "Vervium Cloud AI on Ubuntu."
  instance_type   = "t3.micro"
  region          = "us-east-2"
  source_ami      = data.amazon-ami.ubuntu.id
  ssh_username    = "ubuntu"
}

# Specify the build steps here
build {
  sources = ["source.amazon-ebs.ubuntu"]

  # Copy the app code
  provisioner "file" {
    sources     = ["../app"]
    destination = "/tmp/"
  }

  # Create an app-user and use it to install all the app's dependencies
  provisioner "shell" {
    inline = [
      # Create a more limited user named app-user (this will also create a home dir for that user)
      "sudo useradd -m -s /bin/bash app-user",

      # Copy the app code into app-user's home dir
      "sudo mv /tmp/app /home/app-user",
      "sudo chown -R app-user:app-user /home/app-user/app",

      # As the app-user, install the app's dependencies
      "sudo -u app-user -H bash -lc /home/app-user/app/install-dependencies.sh",

      # Use systemd as a process supervisor, configuring the app to start on boot, and restarting it any time it crashes
      "sudo mv /home/app-user/app/vervium-cloud-ai.service /etc/systemd/system/",
      "sudo systemctl enable vervium-cloud-ai"
    ]
  }
}
