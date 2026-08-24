#!/usr/bin/env bash
# Update script for mcpvault.
#
# Upstream ships a bun-generated package-lock.json that omits `resolved` /
# `integrity` for most entries, which breaks fetchNpmDeps / npm ci. We therefore
# vendor a complete, npm-generated lockfile (see ../default.nix). This script
# keeps it in sync whenever upstream's source (and thus package.json) changes:
#
#   1. bump src (rev + sha256) via nix-update
#   2. unpack the new source
#   3. regenerate a fully-resolved package-lock.json with npm (after removing
#      upstream's bun lockfile) and copy it over the vendored one
#   4. recompute npmDepsHash from the updated vendored lockfile
#
# The update script is invoked with the working directory set to the flake
# root (see run_update_script in nix-update).
set -euo pipefail

pname="mcpvault"
flake_root="$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
pkgdir="$flake_root/pkgs/apps/mcpvault"

if [[ ! -d "$pkgdir" ]]; then
  echo "ERROR: could not locate package directory at $pkgdir (run from the flake root)" >&2
  exit 1
fi

system="${system:-$(nix eval --raw --impure --expr 'builtins.currentSystem' 2>/dev/null || echo x86_64-linux)}"

echo "==> Updating src of $pname"
nix-update "$pname" --flake --version=branch

echo "==> Fetching new source"
src="$(
  nix build --no-link --print-out-paths --impure "path:$flake_root#${pname}.src" 2>/dev/null | tail -n1
)"
if [[ -z "$src" || ! -d "$src" ]]; then
  echo "ERROR: could not resolve new source path" >&2
  exit 1
fi

echo "==> Regenerating package-lock.json from new source"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cp -pr "$src"/. "$tmpdir"/
chmod -R u+w "$tmpdir"
# npm considers the upstream bun lockfile "up to date" and won't re-resolve it,
# so it must be removed to get a fully-resolved lockfile.
rm -f "$tmpdir/package-lock.json" "$tmpdir/npm-shrinkwrap.json"

npm install --package-lock-only --legacy-peer-deps --prefix "$tmpdir"

cp "$tmpdir/package-lock.json" "$pkgdir/package-lock.json"
echo "==> Vendored package-lock.json updated"

echo "==> Recomputing npmDepsHash"
# nix-build fails *expectedly* here (outputHash="" forces a hash-mismatch error
# whose stderr contains the real hash), so temporarily disable set -e / pipefail.
set +e
got="$(
  nix-build --expr "
    let src = (builtins.getFlake (toString \"$flake_root\")).packages.$system.$pname.npmDeps;
    in (src.overrideAttrs or (f: src // f src)) (_: { outputHash = \"\"; outputHashAlgo = \"sha256\"; })
  " 2>&1 | grep -oP 'got:\s+\K(sha256-[A-Za-z0-9+/=]+)' | tail -n1 | tr -d '[:space:]'
)"
set -e
if [[ -z "$got" ]]; then
  echo "ERROR: could not recompute npmDepsHash" >&2
  exit 1
fi

echo "==> Writing npmDepsHash = $got"
python3 - "$pkgdir/default.nix" "$got" <<'PY'
import re, sys
path, new_hash = sys.argv[1], sys.argv[2]
with open(path) as f:
    content = f.read()
content = re.sub(
    r'(npmDepsHash\s*=\s*)"([^"]*)"',
    lambda m: f'{m.group(1)}"{new_hash}"',
    content,
    count=1,
)
with open(path, "w") as f:
    f.write(content)
PY

echo "==> Done. npmDepsHash and vendored lockfile are updated."
