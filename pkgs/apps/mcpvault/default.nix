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
  version = "0-unstable-2026-06-23";
  src = fetchFromGitHub {
    owner = "bitbonsai";
    repo = pname;
    rev = "ed18307c205c4c8bedc242601304fc4c50f63918";
    sha256 = "sha256-3jAb7lWZAK0eEfL4nfYeP+KMnmS3dCfn/JKU0hJ8bf8=";
  };

  npmDepsHash = "sha256-HNkjxMpo2y1v3Jo83mx+ZTVzIG9yyMOlfZ6zUUh3HJw=";

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
