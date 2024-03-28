#!/usr/bin/env bash

set -eu -o pipefail

SOURCE_PATH=_sources
SRC_JSON_FILE=$SOURCE_PATH/generated.json
SRC_NIX_FILE=$SOURCE_PATH/generated.nix
cat _sources/generated.json | jq -r 'to_entries[] | select(.value.passthru | has("yarn-hash")) | .key + "-" + .value.version' | while read -r PKG_VER; do
  echo $SOURCE_PATH/$PKG_VER
  YARN_HASH="$(prefetch-yarn-deps "$SOURCE_PATH/$PKG_VER/yarn.lock")"
  YARN_HASH="$(nix hash to-sri --type sha256 "$YARN_HASH")"
  PKG=$(echo $PKG_VER | sed -e "s/-[^-]*$//g")
  sed -i "s/$PKG-yarn-hash/$YARN_HASH/g" $SRC_JSON_FILE
  sed -i "s/$PKG-yarn-hash/$YARN_HASH/g" $SRC_NIX_FILE
done
