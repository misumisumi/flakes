#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnused

set -eu -o pipefail

PKGNAME=discord-mcp
PKGFILE=./default.nix

sed -i "s|mvnHash = \".*\";|mvnHash = lib.fakeHash;|" "$PKGFILE"
NEW_MVNHASH="$(nix build ".#${PKGNAME}" 2>&1 | tail -n10 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
sed -i "s|mvnHash = lib.fakeHash;|mvnHash = \"${NEW_MVNHASH}\";|" "$PKGFILE"
