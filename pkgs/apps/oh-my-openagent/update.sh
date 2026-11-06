#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq gnused nix

set -euo pipefail

repo="code-yeongyu/oh-my-openagent"
assets=(
  "x86_64-linux omo-linux-x64"
  "aarch64-linux omo-linux-arm64"
  "aarch64-darwin omo-darwin-arm64"
)

# When run via nix-update --use-update-script the script is copied into the
# store, so BASH_SOURCE no longer points at the package directory. nix-update
# runs it with cwd set to the flake root, hence the repo-relative fallback.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${script_dir}/default.nix" ]; then
  file="${script_dir}/default.nix"
else
  file="pkgs/apps/oh-my-openagent/default.nix"
fi

# Upstream sometimes publishes release tags without any binaries (e.g.
# v5.1.52 and v5.1.53), so pick the newest release that actually carries
# every asset we package.
release="$(curl -fsSL "https://api.github.com/repos/${repo}/releases?per_page=100" | jq -c '
  map(select(
    .draft == false and .prerelease == false
    and ([.assets[].name] as $names
         | all(["omo-linux-x64", "omo-linux-arm64", "omo-darwin-arm64"][];
               . as $asset | $names | index($asset) != null))
  ))
  | first
')"

if [ -z "${release}" ] || [ "${release}" = "null" ]; then
  echo "error: no ${repo} release provides all supported assets" >&2
  exit 1
fi

version="$(jq -r '.tag_name | ltrimstr("v")' <<< "${release}")"
old_version="$(sed -n 's/^  version = "\([^"]*\)";/\1/p' "${file}" | head -n1)"

sed -i "s|^  version = \"[^\"]*\";|  version = \"${version}\";|" "${file}"

for entry in "${assets[@]}"; do
  system="${entry%% *}"
  asset="${entry#* }"
  digest="$(jq -r --arg name "${asset}" '.assets[] | select(.name == $name) | .digest' <<< "${release}")"

  if [ -n "${digest}" ] && [ "${digest}" != "null" ]; then
    hash="$(nix hash convert --hash-algo sha256 --to sri "${digest#sha256:}")"
  else
    # GitHub did not always expose asset digests, so fall back to fetching.
    url="https://github.com/${repo}/releases/download/v${version}/${asset}"
    hash="$(nix-prefetch-url --type sha256 "${url}" | xargs nix hash convert --hash-algo sha256 --to sri)"
  fi

  sed -i "/\"${system}\" = {/,/};/ s|^\([[:space:]]*hash = \"\)sha256-[^\"]*\(\";\)|\1${hash}\2|" "${file}"
done

echo "Updated ${repo}: ${old_version} -> ${version}"
