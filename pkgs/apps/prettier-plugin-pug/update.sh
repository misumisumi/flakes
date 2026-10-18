#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

# Update prettier-plugin-pug: version, src hash and the pnpmDeps hash.
#
# The fetchPnpmDeps output is currently identical on every supported platform
# (see the single `hash` in default.nix), so one `--version=skip` pass covers
# them all. If per-platform hashes are ever needed again, compute the other
# systems locally through binfmt emulation (boot.binfmt.emulatedSystems / nix
# extra-platforms) and rewrite each literal individually.
set -eu -o pipefail

pname="prettier-plugin-pug"

# nix-update runs updateScript commands with cwd set to the flake root.
if [ ! -f ./flake.nix ]; then
  cd "$(dirname "$(readlink -f "$0")")/../../.."
fi

nix-update "${pname}" --flake "$@"
# Force hash recomputation even when the version did not change.
nix-update "${pname}" --flake --version=skip "$@"
