#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnused jq yarn-berry.yarn-berry-fetcher nodejs

set -eu -o pipefail

GENERATED_FILE=./_sources/generated.json
HASHES_FILE=./hashes.json

sed -i 's/\(".*"\): *"[^"]*"/\1: "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="/g' "${HASHES_FILE}"

# select including .passthru.pkgmgr == "yarn-berry"
# and get .passthru.extract.["yarn.lock" = "value"]
echo "Step 1: Create missing-hashes.json"
while read -r YARN_FILE; do
  pushd "./_sources/$(dirname "${YARN_FILE}")"
  yarn-berry-fetcher missing-hashes ./yarn.lock >missing-hashes.json
  popd
done < <(jq -r 'to_entries[] | select(.value.passthru.pkgmgr == "yarn-berry") | .value.extract["yarn.lock"]' "${GENERATED_FILE}")

echo "Step 2: Create package-lock.json"
while read -r FILE; do
  pushd "./_sources/$(dirname "${FILE}")"
  npm install --package-lock-only
  popd
done < <(jq -r 'to_entries[] | select(.value.passthru.needGenLock == "yes") | .value.extract["package.json"]' "${GENERATED_FILE}")

echo "Step 3: Update hashes"
tmp=$(mktemp)
while read -r PKGNAME; do
  echo "${PKGNAME}"
  NEW_HASH="$(nix build ".#${PKGNAME}" 2>&1 | tail -n10 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
  jq ".[\"${PKGNAME}\"]=\"${NEW_HASH}\"" "${HASHES_FILE}" >"$tmp" && mv "$tmp" "${HASHES_FILE}"
done < <(jq -r 'keys[]' "${HASHES_FILE}")
