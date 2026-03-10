{
  pkgSource,
  lib,
  buildNpmPackage,
}:
buildNpmPackage {
  inherit (pkgSource) pname src;
  version = pkgSource.date;

  npmDepsHash = "sha256-veQRpP6Bxq0yjDYn07P7TMSdVIT8gWc3czXNfDhrla0=";

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
