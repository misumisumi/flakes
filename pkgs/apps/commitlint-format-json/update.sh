#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnused jq yarn-berry.yarn-berry-fetcher nodejs

set -eu -o pipefail

GENERATED_FILE=../_sources/generated.json

FILE="$(jq -r '.["commitlint-format-json"] | .extract["packages/json/package.json"]' "${GENERATED_FILE}")"
pushd "../_sources/$(dirname "${FILE}")"
npm install --package-lock-only
popd
