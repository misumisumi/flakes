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
  version = "0-unstable-2026-06-18";
  src = fetchFromGitHub {
    owner = "bitbonsai";
    repo = pname;
    rev = "e43125299083d6dc497849052601dc9a2f4a8d25";
    sha256 = "sha256-xiQpIQDHit65s/p5GW0w2oMTGaTkBU7CDuPcCP+AnCI=";
  };

  npmDepsHash = "sha256-/P5MGc46EvxdofsffHOtZLeGnwZUSmX3ZiBKik7m2NM=";

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
