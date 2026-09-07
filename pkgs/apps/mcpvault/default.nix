{
  lib,
  fetchurl,
  buildNpmPackage,
  nix-update-script,
}:
let
  pname = "mcpvault";
  version = "0.16.0";
in
buildNpmPackage {
  inherit pname version;
  src = fetchurl {
    url = "https://registry.npmjs.org/@bitbonsai/mcpvault/-/mcpvault-${version}.tgz";
    sha256 = "sha256-QZsyzmc1nxRr5QzWiE2WGw1LoJ5MsZf73mHbGbyXTS0=";
  };

  dontNpmBuild = true;
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';
  npmDepsHash = "sha256-NXTHDqe8er0y/5n3xZahfT2HNl+IHMIGIjhOwRfEUZ4=";

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
