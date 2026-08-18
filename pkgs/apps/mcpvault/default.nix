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
  version = "0-unstable-2026-08-17";
  src = fetchFromGitHub {
    owner = "bitbonsai";
    repo = pname;
    rev = "5ba7aac77a8dec4c0049bb08f3d7b4b99f01d01e";
    sha256 = "sha256-zXoo71nY4/g8MN1CBJ+fR0io1+EkgxINHrEUCR5TpE0=";
  };

  npmDepsHash = "sha256-D6i839Yj66i2h2cAryqW8Cr7IAftLxKLtDfTpVZLSd0=";

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
