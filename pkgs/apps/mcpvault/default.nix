{
  lib,
  fetchurl,
  buildNpmPackage,
  nix-update-script,
}:
let
  pname = "mcpvault";
  version = "0.18.3";
in
buildNpmPackage {
  inherit pname version;
  src = fetchurl {
    url = "https://registry.npmjs.org/@bitbonsai/mcpvault/-/mcpvault-${version}.tgz";
    sha256 = "sha256-wZOlKcYyVajXfSIqlk+7XL/kfmLK/7H1Ey18nR48efg=";
  };

  dontNpmBuild = true;
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';
  npmDepsHash = "sha256-6WY1yqo2whCsyESDS3ZosTJPrnPC+A4X5V46+CFOpaE=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--generate-lockfile"
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
