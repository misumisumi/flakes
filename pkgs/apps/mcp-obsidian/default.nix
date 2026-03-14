{
  pkgSource,
  lib,
  buildNpmPackage,
}:
buildNpmPackage {
  inherit (pkgSource) pname src;
  version = pkgSource.date;

  npmDepsHash = "sha256-cKEzttAbFBPZ7dhNs4JIcltkIftU2Y5PuxiCFCm14ew=";

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
