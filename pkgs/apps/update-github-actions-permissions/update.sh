#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

# Update update-github-actions-permissions: version and src hash, then force a
# pnpmDeps hash refresh even when the version did not change. The pnpm version
# pinned by nixpkgs moves independently of this package, which invalidates the
# fetchPnpmDeps fixed-output hash.
#
# The pnpm-lock.yaml of this package has no platform-specific
# optionalDependencies, so a single pnpmDeps hash covers all systems. If that
# ever changes, follow pkgs/apps/prettier-plugin-pug/update.sh.
set -eu -o pipefail

pname="update-github-actions-permissions"

# nix-update runs updateScript commands with cwd set to the flake root.
if [ ! -f ./flake.nix ]; then
  cd "$(dirname "$(readlink -f "$0")")/../../.."
fi

nix-update "${pname}" --flake "$@"
nix-update "${pname}" --flake --version=skip "$@"