#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq gnused nix
set -euo pipefail

repo="ibisjp/ibis-office"

# When run via nix-update --use-update-script the script is copied into the
# store, so BASH_SOURCE no longer points at the package directory. nix-update
# runs it with cwd set to the flake root, hence the repo-relative fallback.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${script_dir}/default.nix" ]; then
  file="${script_dir}/default.nix"
else
  file="pkgs/apps/ibis-office-bin/default.nix"
fi

release="$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest")"
version="$(jq -r '.tag_name | ltrimstr("v")' <<< "${release}")"

if [ -z "${version}" ] || [ "${version}" = "null" ]; then
  echo "error: could not determine the latest ${repo} release" >&2
  exit 1
fi

# system asset suffix
platforms=(
  "x86_64-linux Linux-x86_64.flatpak"
  "aarch64-linux Linux-aarch64.flatpak"
  "aarch64-darwin macOS.zip"
)

# Check every asset and compute its hash before touching the file, so a
# release missing an asset does not leave the package half-updated.
declare -A hashes
for entry in "${platforms[@]}"; do
  system="${entry%% *}"
  suffix="${entry#* }"
  asset="ibisOffice-${version}-${suffix}"
  digest="$(jq -r --arg name "${asset}" '.assets[] | select(.name == $name) | .digest' <<< "${release}" | head -n1)"

  if [ -n "${digest}" ] && [ "${digest}" != "null" ]; then
    hashes["${system}"]="$(nix hash convert --hash-algo sha256 --to sri "${digest#sha256:}")"
  else
    if ! jq -e --arg name "${asset}" '.assets[] | select(.name == $name)' <<< "${release}" >/dev/null; then
      echo "error: ${asset} is missing from the v${version} release" >&2
      exit 1
    fi
    url="https://github.com/${repo}/releases/download/v${version}/${asset}"
    hashes["${system}"]="$(nix-prefetch-url --type sha256 "${url}" | xargs nix hash convert --hash-algo sha256 --to sri)"
  fi
done

old_version="$(sed -n 's/^  version = "\([^"]*\)";/\1/p' "${file}" | head -n1)"

sed -i "s|^  version = \"[^\"]*\";|  version = \"${version}\";|" "${file}"

for system in "${!hashes[@]}"; do
  sed -i "/\"${system}\" = {/,/};/ s|^\([[:space:]]*hash = \"\)sha256-[^\"]*\(\";\)|\1${hashes[$system]}\2|" "${file}"
done

echo "Updated ibis-office-bin: ${old_version} -> ${version}"
