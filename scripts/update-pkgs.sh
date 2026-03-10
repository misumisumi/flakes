#!/usr/bin/env bash

set -eu -o pipefail

nix run nixpkgs#python3 -- scripts/update-blender-packages.py pkgs/apps/packages.toml

TEMP=$(mktemp -u)
nix run "nixpkgs#nvfetcher" -- -c pkgs/apps/packages.toml -o pkgs/apps/_sources -l "${TEMP}" -k ./keyfile.toml
if [ "$(grep snack "${TEMP}")" != "" ]; then
  pushd pkgs/apps/snack
  eval "$(nix build ".#snack.passthru.fetchPatch" --print-out-paths --no-link)"
  popd
fi
if [ "$(grep wavesurfer "${TEMP}")" != "" ]; then
  pushd pkgs/apps/wavesurfer
  eval "$(nix build ".#wavesurfer.passthru.fetchPatch" --print-out-paths --no-link)"
  popd
fi

nix run "nixpkgs#nvfetcher" -- -c pkgs/apps/prettier-plugins/plugins.toml -o pkgs/apps/prettier-plugins/_sources -k ./keyfile.toml
nix run "nixpkgs#nvfetcher" -- -c pkgs/python-modules/packages.toml -o pkgs/python-modules/_sources -k ./keyfile.toml
nix run "nixpkgs#nvfetcher" -- -c pkgs/zotero-addons/addons.toml -o pkgs/zotero-addons/_sources -k ./keyfile.toml

while read -r DIR; do
  echo "Updating ${DIR}"
  pushd "${DIR}"
  ./update.sh
  popd
done < <(find ./ -type f -name "update.sh" -exec dirname {} \;)
