#!/usr/bin/env python3
"""Refresh the Blender entries in pkgs/apps/packages.toml using the AUR versions."""

import argparse
import json
import re
import sys
import time
from urllib import error, request

AUR_RPC_URL = "https://aur.archlinux.org/rpc/?v=5&type=info"

SECTION_TEMPLATES = {
    "blender-bin_lts": '[blender-bin_lts]\nsrc.github_tag = "blender/blender"\nsrc.include_regex = "v{major_minor}.*"\nsrc.prefix = "v"\nfetch.url = "https://ftp.nluug.nl/pub/graphics/blender/release/Blender{major_minor}/blender-$ver-linux-x64.tar.xz"\n\n',
    "blender-bin": '[blender-bin]\nsrc.github_tag = "blender/blender"\nsrc.include_regex = "v{major_minor}.*"\nsrc.prefix = "v"\nfetch.url = "https://ftp.nluug.nl/pub/graphics/blender/release/Blender{major_minor}/blender-$ver-linux-x64.tar.xz"\n\n',
}

AUR_TO_SECTION = [
    ("blender-lts-bin", "blender-bin_lts"),
    ("blender-bin", "blender-bin"),
]

SECTION_ALIASES = {
    "blender-bin_lts": ["blender-bin"],
    "blender-bin": ["blender-bin_latest"],
}

SECTION_PATTERN = re.compile(r"(?ms)^\[(?P<section>[^\]]+)\]\n.*?(?=\n\[|\Z)")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("packages", help="Path to pkgs/apps/packages.toml")
    return parser.parse_args()


def fetch_aur_versions(names):
    query = "".join(f"&arg[]={name}" for name in names)
    url = AUR_RPC_URL + query
    attempts = 3
    for attempt in range(attempts):
        try:
            with request.urlopen(url, timeout=30) as resp:
                payload = json.load(resp)
            break
        except error.URLError as exc:
            if attempt == attempts - 1:
                sys.exit(f"Failed to fetch AUR data: {exc}")
            time.sleep(1)

    if "results" not in payload:
        sys.exit('Unexpected AUR response: missing "results"')

    result = {entry["Name"]: entry["Version"] for entry in payload["results"]}
    missing = [name for name in names if name not in result]
    if missing:
        sys.exit(f"AUR response missing packages: {missing}")

    return result


def normalize_version(version):
    upstream = version.split("-", 1)[0]
    parts = upstream.split(".")
    if len(parts) == 1:
        parts.append("0")
    return f"{parts[0]}.{parts[1]}"


def build_section(section_name, major_minor):
    template = SECTION_TEMPLATES.get(section_name)
    if template is None:
        raise ValueError(f"No template for section {section_name}")
    return template.format(major_minor=major_minor)


def replace_section(text, section_name, new_section, aliases=None):
    pattern = re.compile(rf"(?ms)^\[{re.escape(section_name)}\]\n.*?(?=\n\[|\Z)")
    match = pattern.search(text)
    if match:
        return text[: match.start()] + new_section + text[match.end() :]

    if aliases:
        for alias in aliases:
            pattern = re.compile(rf"(?ms)^\[{re.escape(alias)}\]\n.*?(?=\n\[|\Z)")
            match = pattern.search(text)
            if match:
                return text[: match.start()] + new_section + text[match.end() :]

    return None


def insert_section(text, new_section, anchor_name):
    anchor = re.compile(rf"(?ms)^\[{re.escape(anchor_name)}\]\n.*?(?=\n\[|\Z)")
    anchor_match = anchor.search(text)
    if not anchor_match:
        raise ValueError(f"Reference section [{anchor_name}] not found when inserting section")
    return text[: anchor_match.end()] + "\n" + new_section + text[anchor_match.end():]


def remove_section(text, section_name):
    pattern = re.compile(rf"(?ms)^\[{re.escape(section_name)}\]\n.*?(?=\n\[|\Z)")
    return pattern.sub("", text)


def main():
    args = parse_args()
    versions = fetch_aur_versions([aur for aur, _ in AUR_TO_SECTION])

    replacements = {}
    for aur_name, section_name in AUR_TO_SECTION:
        version = versions[aur_name]
        major_minor = normalize_version(version)
        replacements[section_name] = (version, build_section(section_name, major_minor))

    try:
        with open(args.packages, "r", encoding="utf-8") as f:
            content = f.read()
    except FileNotFoundError:
        sys.exit(f"Packages file not found: {args.packages}")

    def ensure_or_insert(section_name, section_text):
        updated = replace_section(
            content,
            section_name,
            section_text,
            aliases=SECTION_ALIASES.get(section_name),
        )
        if updated is not None:
            return updated

        if section_name == "blender-bin":
            return insert_section(content, section_text, "blender-bin_lts")

        return section_text + content

    lts_version, lts_section = replacements["blender-bin_lts"]
    content = ensure_or_insert("blender-bin_lts", lts_section)

    latest_version, latest_section = replacements["blender-bin"]
    content = ensure_or_insert("blender-bin", latest_section)

    content = remove_section(content, "blender-bin_latest")

    with open(args.packages, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"Updated blender-bin_lts to {lts_version}")
    print(f"Updated blender-bin to {latest_version}")


if __name__ == "__main__":
    main()
