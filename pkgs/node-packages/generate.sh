#!/usr/bin/env bash

set -eu -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# Track the latest active nodejs LTS here: https://nodejs.org/en/about/releases/
# node2nix generated composition.nix too old so not generating it
nix run nixpkgs#node2nix -- \
  -i node-packages.json \
  -o node-packages.nix \
  -c /dev/null \
  --no-copy-node-env \
  --pkg-name nodejs_22
