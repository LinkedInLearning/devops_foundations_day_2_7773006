#!/usr/bin/env bash
# A script to update a .tfvars.json file with a given value, and to commit and push those changes to main.

set -eo pipefail

if [[ "$#" -ne 4 ]]; then
  echo "Invalid number of arguments."
  echo "Usage: ./update-tfvars-json.sh TFVARS_PATH KEY VALUE MESSAGE"
  echo
  echo "Where:"
  echo
  echo "  TFVARS_PATH: the path to the .tfvars.json file to update"
  echo "  KEY: the key to update in the file"
  echo "  VALUE: the value to set for KEY"
  echo "  MESSAGE: the commit message"
  exit 1
fi

tfvars_path="$1"
key="$2"
value="$3"
message="$4"

echo "Setting $key to $value in $tfvars_path"
updated_tfvars="$(jq --arg "key" "$key" --arg "value" "$value" '.[$key] = $value' "$tfvars_path")"
printf '%s\n' "$updated_tfvars" > "$tfvars_path"

echo "Committing and pushing changes to the main branch"
git add "$tfvars_path"

if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

# We do commits from the standard username and email of the GitHub Actions bot:
# https://github.com/orgs/community/discussions/26560
git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

git commit -m "$message"
git push origin HEAD:main