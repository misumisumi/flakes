#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq gnused nix nix-prefetch-git

# Updates AutoVirt (anti-anti-cheat-patch) from the Forgejo mirror.
#
# Besides bumping the AutoVirt revision, this script also pins the qemu and
# edk2 versions to the newest ones the AutoVirt patch set actually ships (a
# matching amd AND intel patch for that exact version) and refreshes their
# hashes.  That way the fixed-qemu / fixed-edk2 overrides can never outrun
# upstream patch support.
#
# NOTE: nix-update cannot update this package on its own. It probes
# `https://{host}/api/v1/settings/api` with Python's default urllib
# User-Agent to decide whether a host is Gitea/Forgejo (is_gitea_host),
# and Cloudflare in front of git.keyemail.dev answers that with HTTP 403.
# nix-update therefore misclassifies the archive URL as GitHub and fails.
# This script queries the Forgejo API directly instead.

set -euo pipefail

owner="Scrut1ny"
repo="AutoVirt"
branch="main"
forgejo="https://git.keyemail.dev"

# Non-empty UA: Cloudflare rejects requests without one.
user_agent="nix-update-anti-anti-cheat-patch/1.0 (+https://git.keyemail.dev/${owner}/${repo})"

# When run via nix-update --use-update-script the script is copied into the
# store, so BASH_SOURCE no longer points at the package directory. nix-update
# runs it with cwd set to the flake root, hence the repo-relative fallback.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${script_dir}/default.nix" ]; then
  file="${script_dir}/default.nix"
else
  file="pkgs/apps/anti-anti-cheat-patch/default.nix"
fi
api="${forgejo}/api/v1/repos/${owner}/${repo}"

curl_json() { curl -fsSL -A "${user_agent}" "$1"; }

# Read a field of the form `name = "...";` from inside the block that starts
# with the given regex and ends at the first `  });` line.
block_field() { # block-start-regex field
  sed -n "/$1/,/^  });/ s/^[[:space:]]*$2 = \"\([^\"]*\)\";/\1/p" "${file}" | head -n1
}

# Emit "<version> <vendor>" for every amd/intel patch filename in an API dir.
list_supported() { # dir
  curl_json "${api}/contents/patches/$1?ref=${rev}" \
    | jq -r '.[]?.name // empty' \
    | while read -r name; do
        lower="${name,,}"
        case "${lower}" in
          amd*.patch) vendor="amd" ;;
          intel*.patch) vendor="intel" ;;
          *) continue ;;
        esac
        base="${lower%.patch}"
        ver="$(grep -oE '[0-9]+(\.[0-9]+)*' <<<"${base}" | tail -n1 || true)"
        if [ -n "${ver}" ]; then
          printf '%s %s\n' "${ver}" "${vendor}"
        fi
      done
}

# Newest version that has both an amd and an intel patch across the given dirs.
newest_common() { # dirs...
  for dir in "$@"; do
    list_supported "${dir}"
  done \
    | sort -u \
    | awk '{ if ($2 == "amd") a[$1] = 1; else if ($2 == "intel") i[$1] = 1 }
           END { for (v in a) if (v in i) print v }' \
    | sort -V | tail -n1
}

# True when $1 is strictly newer than $2.
is_newer() {
  [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -n1)" = "$1" ]
}

# ---- AutoVirt revision ---------------------------------------------------
commit_json="$(curl_json "${api}/commits?sha=${branch}&limit=1&stat=false&verification=false&files=false")"
rev="$(jq -r '.[0].sha' <<<"${commit_json}")"
date="$(jq -r '.[0].commit.committer.date' <<<"${commit_json}" | cut -dT -f1)"

if [ -z "${rev}" ] || [ "${rev}" = "null" ]; then
  echo "error: failed to fetch latest commit of ${branch}" >&2
  exit 1
fi

# Prefer the latest tag when the mirror carries them, otherwise date the snapshot.
tags_json="$(curl_json "${api}/tags?limit=1")"
tag="$(jq -r '.[0].name // empty' <<<"${tags_json}")"
if [ -n "${tag}" ]; then
  version="${tag#v}"
else
  version="0-unstable-${date}"
fi

old_version="$(sed -n 's/^  version = "\([^"]*\)";/\1/p' "${file}" | head -n1)"
old_rev="$(sed -n 's/^[[:space:]]*rev = "\([^"]*\)";/\1/p' "${file}" | head -n1)"
old_qemu_version="$(block_field 'fixed-qemu = qemu.overrideAttrs' 'version')"
old_qemu_hash="$(block_field 'fixed-qemu = qemu.overrideAttrs' 'hash')"
old_edk2_version="$(block_field 'fixed-edk2 = edk2.overrideAttrs' 'version')"
old_edk2_hash="$(block_field 'fixed-edk2 = edk2.overrideAttrs' 'hash')"

# ---- Versions supported by the AutoVirt patch set ------------------------
qemu_target="$(newest_common QEMU QEMU/Archive)"
edk2_target="$(newest_common EDK2 EDK2/Archive)"
if [ -z "${qemu_target}" ] || [ -z "${edk2_target}" ]; then
  echo "error: could not determine AutoVirt-supported qemu/edk2 versions" >&2
  exit 1
fi

qemu_change=true
is_newer "${qemu_target}" "${old_qemu_version}" || qemu_change=false
edk2_change=true
is_newer "${edk2_target}" "${old_edk2_version}" || edk2_change=false

if [ "${version}" = "${old_version}" ] && [ "${rev}" = "${old_rev}" ] \
  && [ "${qemu_change}" = false ] && [ "${edk2_change}" = false ]; then
  echo "${repo} is already up to date: ${version} (${rev})"
  echo "qemu ${old_qemu_version}, edk2 ${old_edk2_version} are the newest AutoVirt supports"
  exit 0
fi

# ---- Hashes --------------------------------------------------------------
av_url="${forgejo}/${owner}/${repo}/archive/${rev}.tar.gz"
av_hash="$(nix-prefetch-url --unpack "${av_url}" | xargs nix-hash --to-sri --type sha256)"

qemu_hash="${old_qemu_hash}"
if [ "${qemu_change}" = true ]; then
  qemu_hash="$(nix-prefetch-url "https://download.qemu.org/qemu-${qemu_target}.tar.xz" \
    | xargs nix-hash --to-sri --type sha256)"
fi

edk2_hash="${old_edk2_hash}"
if [ "${edk2_change}" = true ]; then
  edk2_hash="$(nix-prefetch-git \
      --url https://github.com/tianocore/edk2 \
      --rev "edk2-stable${edk2_target}" \
      --fetch-submodules 2>/dev/null | jq -r '.hash')"
fi

# ---- Apply ---------------------------------------------------------------
sed -i \
  -e "s|^  version = \"[^\"]*\";|  version = \"${version}\";|" \
  -e "s|^\([[:space:]]*\)rev = \"[^\"]*\";|\1rev = \"${rev}\";|" \
  -e "s|^\([[:space:]]*\)sha256 = \"sha256-[^\"]*\";|\1sha256 = \"${av_hash}\";|" \
  -e "/fixed-qemu = qemu.overrideAttrs/,/^  });/ s|^\([[:space:]]*\)version = \"[^\"]*\";|\1version = \"${qemu_target}\";|" \
  -e "/fixed-qemu = qemu.overrideAttrs/,/^  });/ s|^\([[:space:]]*\)hash = \"sha256-[^\"]*\";|\1hash = \"${qemu_hash}\";|" \
  -e "/fixed-edk2 = edk2.overrideAttrs/,/^  });/ s|^\([[:space:]]*\)version = \"[^\"]*\";|\1version = \"${edk2_target}\";|" \
  -e "/fixed-edk2 = edk2.overrideAttrs/,/^  });/ s|^\([[:space:]]*\)hash = \"sha256-[^\"]*\";|\1hash = \"${edk2_hash}\";|" \
  "${file}"

echo "Updated ${repo}: ${old_version} -> ${version} (${rev})"
if [ "${qemu_change}" = true ]; then
  echo "Updated qemu: ${old_qemu_version} -> ${qemu_target}"
fi
if [ "${edk2_change}" = true ]; then
  echo "Updated edk2: ${old_edk2_version} -> ${edk2_target}"
fi
