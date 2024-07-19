#!/usr/bin/env bash

# yarnパッケージはyarnHashが必要だがnvfetcherはこれの抽出に対応していない
# yarnHashはprefetch-yarn-depsで取得可能
# passthru = {yarn-hash=<pkg-name>-yarn-hash}とすることで定義しておくことで、
# nvfetcherでの更新後に該当部分をprefetch-yarn-depsで取得したハッシュに置換することで対応する

set -eu -o pipefail

SOURCE_PATH=_sources
SRC_JSON_FILE=$SOURCE_PATH/generated.json
SRC_NIX_FILE=$SOURCE_PATH/generated.nix
cat _sources/generated.json | jq -r 'to_entries[] | select(.value.passthru | has("yarn-hash")) | .key + "-" + .value.version' | while read -r PKG_VER; do
  echo $SOURCE_PATH/$PKG_VER
  YARN_HASH="$(nix run nixpkgs#prefetch-yarn-deps -- "$SOURCE_PATH/$PKG_VER/yarn.lock")"
  YARN_HASH="$(nix hash to-sri --type sha256 "$YARN_HASH")"
  PKG=$(echo $PKG_VER | sed -e "s/-[^-]*$//g")
  sed -i "s/$PKG-yarn-hash/$YARN_HASH/g" $SRC_JSON_FILE
  sed -i "s/$PKG-yarn-hash/$YARN_HASH/g" $SRC_NIX_FILE
done
