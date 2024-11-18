#!/usr/bin/env bash

set -eu -o pipefail
PKG_TOML=pkgs/packages.toml
NEW_PKG_TOML=${PKG_TOML}.new

# proton-ge-rtsp
repo="SpookySkeletons/proton-ge-rtsp"
tagName=$(gh release list --exclude-drafts --exclude-pre-releases -L 1 --repo "${repo}" --json "tagName" -q ".[].tagName")
assetURL=$(gh release view "${tagName}" --repo "${repo}" --json "assets" --jq ".assets[0].url")
assetURL=${assetURL} tomlq -i -t '.["proton-ge-rtsp-bin"].fetch.tarball = env.assetURL' ${PKG_TOML}
