#!/usr/bin/env bash
# A script to install all the app's dependencies

set -eo pipefail

# Install mise
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

# Use mise to install Node.js and NPM
cd "$HOME/app"
mise trust .mise.toml
mise install node
mise use node

# Use NPM to install the app's dependencies
npm ci --omit=dev