#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

# Update package versions and refresh hashes (src and pnpmDeps) for this flake.
#
# Usage:
#   scripts/update-pnpm.sh                       # update every package
#   scripts/update-pnpm.sh <package> [flags...]  # update a single package
#   ONLY=<package> scripts/update-pnpm.sh        # limit the sweep to one package
#
# The single-package mode is also meant to be used as a package updateScript,
# e.g. in pkgs/<...>/default.nix:
#
#   passthru.updateScript = {
#     command = [ ../../../scripts/update-pnpm.sh "<pname>" ];
#   };
#
# It intentionally never passes --use-update-script: this script *is* the
# updateScript in that context, and delegating would recurse.
#
# The --version=skip pass keeps the version but forces hash recomputation, so
# pnpmDeps hashes follow the pnpm version pinned by the current flake.lock.
set -eu -o pipefail

# When invoked through an updateScript, nix-update already runs the command
# with cwd set to the flake root and $0 points into /nix/store.
if [ ! -f ./flake.nix ]; then
  cd "$(dirname "$(readlink -f "$0")")/.."
fi

system=$(nix eval --raw --impure --expr 'builtins.currentSystem')

refresh_pnpm_deps() {
  local name=$1
  shift
  echo "==> Refreshing pnpmDeps hash for ${name}"
  nix-update "${name}" --flake --version=skip "$@"
}

if [ $# -gt 0 ] && [ "${1#-}" = "$1" ]; then
  name=$1
  shift
  echo "==> Updating ${name}"
  nix-update "${name}" --flake "$@"
  if [ "$(nix eval --raw --impure --apply 'p: if p ? pnpmDeps then "yes" else "no"' ".#packages.${system}.${name}")" = "yes" ]; then
    refresh_pnpm_deps "${name}" "$@"
  fi
  exit 0
fi

# One line per updatable package: "<name> [use-script] [pnpm-deps]"
targets=$(
  nix eval --raw --impure --apply 'ps:
    builtins.concatStringsSep "\n" (builtins.concatMap (n:
      let
        p = ps.${n};
        useScript = (p.passthru ? updateScript) && (p.passthru.useUpdateScript or true);
        flags = [ n ]
          ++ (if useScript then [ "use-script" ] else [ ])
          ++ (if p ? pnpmDeps then [ "pnpm-deps" ] else [ ]);
      in
      if (p.passthru.skipUpdate or false) || !(p ? src) then [ ] else [ (builtins.concatStringsSep " " flags) ]
    ) (builtins.attrNames ps))' ".#packages.${system}"
)

while read -r name use_script pnpm_deps; do
  if [ -z "${name:-}" ]; then
    continue
  fi
  if [ -n "${ONLY:-}" ] && [ "$name" != "$ONLY" ]; then
    continue
  fi

  echo "==> Updating ${name}"
  if [ "${use_script:-}" = "use-script" ]; then
    nix-update "${name}" --flake --use-update-script "$@"
  else
    nix-update "${name}" --flake "$@"
  fi

  if [ "${pnpm_deps:-}" = "pnpm-deps" ]; then
    refresh_pnpm_deps "${name}" "$@"
  fi
done <<< "$targets"