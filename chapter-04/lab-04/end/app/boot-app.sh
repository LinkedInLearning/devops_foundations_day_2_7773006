#!/usr/bin/env bash
# A script to run the app on an EC2 instance. It fills in the environment name in the CloudWatch Agent config file,
# and then starts CloudWatch Agent. It also fills in the environment name in the environment file used by the app's
# systemd unit configuration, and then starts the app.

set -eo pipefail

if [[ "$#" -ne 1 ]]; then
  echo "ERROR: expected exactly one argument, got $#"
  echo "Usage: boot-app.sh <ENVIRONMENT_NAME>"
  exit 1
fi

readonly ENVIRONMENT_NAME="$1"

# Fill in the environment name in the CloudWatch Agent config file
sudo sed -i "s/__ENVIRONMENT_NAME__/$ENVIRONMENT_NAME/g" /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Configure CloudWatch Agent to run on boot, and start it
sudo systemctl enable --now amazon-cloudwatch-agent

# Fill in the environment name in the environment file used by the app's systemd unit configuration
sudo sed -i "s/__ENVIRONMENT_NAME__/$ENVIRONMENT_NAME/g" /home/app-user/app/vervium-cloud-ai.env

# Configure the app to run on boot, and start it
sudo systemctl enable --now vervium-cloud-ai
