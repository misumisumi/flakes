{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
}:
let
  pname = "mcpvault";
in
buildNpmPackage {
  inherit pname;
  version = "0-unstable-2026-07-23";
  src = fetchFromGitHub {
    owner = "bitbonsai";
    repo = pname;
    rev = "313983bffcfb8e2e6b6c4c9f977cf0bffdc9e8c6";
    sha256 = "sha256-WNjH97F58YVOLKshyxJTXksI4OmXE9KKmsWtnkTdaTM=";
  };

  npmDepsHash = "sha256-JiQXpqyqoF6X+8QXob4hWzbLwiN4GnuFAeEM9xZGu0o=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "A lightweight Model Context Protocol (MCP) server for safe Obsidian vault access";
    homepage = "https://github.com/bitbonsai/mcp-obsidian";
    mainProgram = "mcp-obsidian";
    lisense = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
