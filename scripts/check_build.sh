#! /usr/bin/env bash
start=$1
end=$2

nix flake show --json | jq -r '.packages."x86_64-linux" | keys | .[]' | tail -n+"${start}" | head -n"${end}" | while read -r pkg; do
  nix build --no-link ".#${pkg}" || exit 1
done