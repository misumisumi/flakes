#! /usr/bin/env nix-shell
#!nix-shell -i bash -p cpulimit gnused jq
# shellcheck shell=bash

# Build only the checks affected by a pull request.
#
# ALL and DIRS come from the pre-build job (see scripts/changed-pkgs.sh).
# Attribute names are resolved here because only the runner knows which
# checks exist for its system.
set -euo pipefail

all=${ALL:-false}
dirs=${DIRS:-[]}

system=$(nix eval --raw --impure --expr builtins.currentSystem)

if [ "$all" = true ]; then
  select='checks: checks'
else
  names=$(nix eval --json ".#checks.${system}" --apply builtins.attrNames)
  zotero_addons=$(sed -nE 's/^  ([A-Za-z0-9_.-]+) =.*/\1/p' pkgs/zotero-addons/addons.nix | jq -R . | jq -sc .)
  # Most package directories map to an attribute of the same name. Directories
  # that produce several attributes, or that affect other packages, are
  # matched explicitly here.
  keep=$(jq -c --argjson dirs "$dirs" --argjson zotero "$zotero_addons" '
    def selected($name):
      any($dirs[];
        if . == "blender-bin" then ($name | startswith("blender-bin"))
        elif . == "aac-edk2-qemu" then ($name | startswith("aac-"))
        elif . == "anti-anti-cheat-patch" then
          $name == "anti-anti-cheat-patch" or ($name | startswith("aac-"))
        elif . == "zotero-addons" then ($zotero | index($name)) != null
        else $name == .
        end);
    [ .[] | select(selected(.)) ]
  ' <<<"$names")

  if [ "$keep" = "[]" ]; then
    echo "No checks to build for ${system}"
    echo '{"results":[]}' > result.json
    exit 0
  fi

  attrs=$(jq -r 'map("\"\(.)\" = null;") | "{ " + join(" ") + " }"' <<<"$keep")
  select="checks: builtins.intersectAttrs ${attrs} checks"
fi

cpulimit -l 85 -i -- nix run github:Mic92/nix-fast-build -- \
  --no-link \
  --no-nom \
  --result-file result.json \
  --flake ".#checks.${system}" \
  --select "$select"
