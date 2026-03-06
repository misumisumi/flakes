#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnused

set -eu -o pipefail

PKGNAME=update-github-actions-permissions
PKGFILE=./default.nix

sed -i "s|hash = \".*\";|hash = lib.fakeHash;|" "$PKGFILE"
NEW_PNPMHASH="$(nix build ".#${PKGNAME}" 2>&1 | tail -n10 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
sed -i "s|hash = lib.fakeHash;|hash = \"${NEW_PNPMHASH}\";|" "$PKGFILE"
