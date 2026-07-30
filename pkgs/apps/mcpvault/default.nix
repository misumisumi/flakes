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
  version = "0-unstable-2026-07-30";
  src = fetchFromGitHub {
    owner = "bitbonsai";
    repo = pname;
    rev = "6bef558e42da7c896d2c95c6479848286889ac70";
    sha256 = "sha256-KASgYzq9WQLtNZN1iFM7fROgIzlnE/P4YDTgD2yHhHc=";
  };

  npmDepsHash = "sha256-EHF+ai+rdx73DUMhIlX/GN7PBZ6wOD8gbKCSIVjifuE=";

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
