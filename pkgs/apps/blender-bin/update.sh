#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl jq gnused

set -eu -o pipefail
pname=$1
aur=$2

# Fetch version from AUR for a single package
fetch_aur_version() {
  local package="$1"
  local url="https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=${package}"

  response=$(curl -s --max-time 30 "$url" 2>/dev/null)

  if [ -n "$response" ] && echo "$response" | jq -e '.results[0]' >/dev/null 2>&1; then
    echo "$response" | jq -r '.results[0].Version' | sed "s/-.*//g"
    return 0
  else
    echo "Error: Failed to fetch version for $package" >&2
    return 1
  fi
}

version=$(fetch_aur_version "$aur")
nix-update "$pname" --flake --version "$version" --url "https://github.com/blender/blender" --override-filename pkgs/apps/blender-bin/default.nix
