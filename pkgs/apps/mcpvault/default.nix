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
  version = "0-unstable-2026-05-25";
  src = fetchFromGitHub {
    owner = "bitbonsai";
    repo = pname;
    rev = "488a9076f84fdc8d5818c11eb4f8e2cdbfd74e8c";
    sha256 = "sha256-Hd3ml5FmD9/EvhcWfX3AgF1vJQmBQRhRbIb+rW56N8A=";
  };

  npmDepsHash = "sha256-D9DCHEw9L2/crhOcp80YB3CRxL6EZ5CxoiiuoN/Xsx0=";

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
