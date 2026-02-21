#!/usr/bin/env bash

# mevenパッケージはmvnHashが必要だがnvfetcherはこれの抽出に対応していない
# mvnHashはnix buildで取得可能
# passthru = {mvnHash=<old_mvnHash>}とすることで定義しておくことで、
# nvfetcherでの更新後に該当部分を取得したハッシュに置換することで対応する

set -eu -o pipefail

PKG_TOML=pkgs/packages.toml
SOURCE_PATH=_sources
SRC_JSON_FILE=$SOURCE_PATH/generated.json
SRC_NIX_FILE=$SOURCE_PATH/generated.nix
cat _sources/generated.json | jq -r 'to_entries[] | select(.value.passthru | has("mvnHash")) | .key + "," + .value.passthru.mvnHash' | while read -r PKG_HASH; do
  PKGNAME=$(echo "$PKG_HASH" | cut -d, -f1)
  OLD_MVNHASH=$(echo "$PKG_HASH" | cut -d, -f2-)
  NEW_MVNHASH="$(nix build ".#${PKGNAME}" 2>&1 | tail -n10 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
  if [ ! -z "$NEW_MVNHASH" ]; then
    echo "Old mvnHash: $OLD_MVNHASH"
    echo "New mvnHash: $NEW_MVNHASH"
    sed -i -e "s%$OLD_MVNHASH%$NEW_MVNHASH%g" $PKG_TOML
    sed -i -e "s%$OLD_MVNHASH%$NEW_MVNHASH%g" $SRC_JSON_FILE
    sed -i -e "s%$OLD_MVNHASH%$NEW_MVNHASH%g" $SRC_NIX_FILE
  fi
done
