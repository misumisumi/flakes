#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnused

# Update prettier-plugin-pug: version and src hash, then the pnpmDeps hash of
# every supported platform.
#
# pnpm materializes platform-specific optionalDependencies
# (@esbuild/linux-x64 vs @esbuild/linux-arm64), so the fetchPnpmDeps
# fixed-output hash differs per system and default.nix keeps a per-system
# hash literal (see the if/else around pnpmDeps.hash).
#
# Non-native systems are computed locally through binfmt emulation
# (boot.binfmt.emulatedSystems / nix extra-platforms). Without them the
# failing system is skipped and its hash has to be taken from CI.
set -eu -o pipefail

pname="prettier-plugin-pug"
pnpm_deps_file="pkgs/apps/prettier-plugin-pug/default.nix"

# nix-update runs updateScript commands with cwd set to the flake root.
if [ ! -f ./flake.nix ]; then
  cd "$(dirname "$(readlink -f "$0")")/../../.."
fi

current_system=$(nix eval --raw --impure --expr 'builtins.currentSystem')

nix-update "${pname}" --flake "$@"
# Force hash recomputation even when the version did not change.
nix-update "${pname}" --flake --version=skip "$@"

systems=$(nix eval --raw --impure --apply 'ps: builtins.concatStringsSep " " ps' ".#packages.${current_system}.${pname}.meta.platforms")

for sys in ${systems}; do
  if [ "${sys}" = "${current_system}" ]; then
    continue
  fi

  cur=$(nix eval --raw ".#packages.${sys}.${pname}.pnpmDeps.outputHash")
  got=$(
    nix build --impure --no-link --expr "
      let
        pkg = (builtins.getFlake (toString ./.)).packages.${sys}.${pname}.pnpmDeps;
      in
      pkg.overrideAttrs (_: {
        outputHash = \"\";
        outputHashAlgo = \"sha256\";
      })
    " 2>&1 | sed -n 's/.*got:[[:space:]]*\(sha256-[A-Za-z0-9+/=]*\).*/\1/p' | head -n 1
  ) || true

  if [ -z "${got}" ]; then
    echo "warning: could not compute ${pname} pnpmDeps hash for ${sys} locally; take it from CI" >&2
    continue
  fi
  if [ "${got}" = "${cur}" ]; then
    continue
  fi

  echo "==> Updating ${pname} pnpmDeps hash for ${sys}: ${cur} -> ${got}"
  if ! grep -qF "${cur}" "${pnpm_deps_file}"; then
    echo "error: current ${sys} hash ${cur} not found in ${pnpm_deps_file}" >&2
    exit 1
  fi
  sed -i "s|${cur}|${got}|g" "${pnpm_deps_file}"
done