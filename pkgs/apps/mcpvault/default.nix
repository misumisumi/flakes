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
  version = "0-unstable-2026-08-06";
  src = fetchFromGitHub {
    owner = "bitbonsai";
    repo = pname;
    rev = "b6a0798836b2b5fee8750fa68c23028fbab94632";
    sha256 = "sha256-ZrVF6PVjqNGt9dy9dWNXU8l+K6TiBr7naJ1IPQR7nd8=";
  };

  npmDepsHash = "sha256-69i6Jvi3HVEf2ZXbFG0s9mtJJC63bYVnz0cGGP8DkPY=";

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
