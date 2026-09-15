#!/usr/bin/env bash
set -euo pipefail

if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

cd "$(dirname "$0")/.."

mise trust .mise.toml
mise install
