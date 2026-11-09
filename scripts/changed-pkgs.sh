#! /usr/bin/env nix-shell
#!nix-shell -i bash -p jq
# shellcheck shell=bash

# Determine which checks need to be built for a pull request.
#
# Reads the files changed between BASE_SHA and HEAD_SHA and writes the
# following GitHub Actions outputs:
#
#   check  "true" when a build-relevant file changed
#   all    "true" when every check must be built
#   dirs   JSON array of changed package directories or special markers
#
# Attribute names are resolved in the build job (see build-check.yml), where
# the attributes that actually exist for the runner's system are known.
set -euo pipefail

base=${BASE_SHA:?BASE_SHA is required}
head=${HEAD_SHA:?HEAD_SHA is required}
output=${GITHUB_OUTPUT:-/dev/stdout}

if ! changed=$(git diff --name-only "$base...$head"); then
  # Build everything rather than silently skipping when the diff fails.
  {
    echo "check=true"
    echo "all=true"
    echo "dirs=[]"
  } >> "$output"
  exit 0
fi

check=false
all=false
declare -A seen=()
dirs=()

add_dir() {
  local dir=$1
  [ -n "${seen[$dir]:-}" ] && return 0
  seen[$dir]=1
  dirs+=("$dir")
}

while IFS= read -r file; do
  [ -n "$file" ] || continue
  case "$file" in
    flake.lock | flake.nix | lib.nix)
      check=true
      all=true
      ;;
    pkgs/utils.nix | pkgs/apps/default.nix | pkgs/python-modules/default.nix | pkgs/overrides/*)
      check=true
      all=true
      ;;
    pkgs/apps/*/* | pkgs/python-modules/*/*)
      check=true
      package=${file#pkgs/}
      package=${package#*/}
      add_dir "${package%%/*}"
      ;;
    pkgs/zotero-addons/*)
      check=true
      add_dir zotero-addons
      ;;
    pkgs/*)
      # Unknown shared file: build everything to stay on the safe side.
      check=true
      all=true
      ;;
  esac
done <<< "$changed"

if [ "$all" = true ]; then
  dirs=()
fi

{
  echo "check=$check"
  echo "all=$all"
  if [ ${#dirs[@]} -eq 0 ]; then
    echo "dirs=[]"
  else
    echo "dirs=$(printf '%s\n' "${dirs[@]}" | jq -R . | jq -sc .)"
  fi
} >> "$output"
