#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq gnused

set -eu -o pipefail

PKGNAME=mcpvault
PKGFILE=./default.nix

sed -i "s|npmDepsHash = \".*\";|npmDepsHash = lib.fakeHash;|" "$PKGFILE"
NEW_NPMDEPSHASH="$(nix build ".#${PKGNAME}" 2>&1 | tail -n10 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
sed -i "s|npmDepsHash = lib.fakeHash;|npmDepsHash = \"${NEW_NPMDEPSHASH}\";|" "$PKGFILE"
