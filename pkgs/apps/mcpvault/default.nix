{
  lib,
  fetchurl,
  buildNpmPackage,
  nix-update-script,
}:
let
  pname = "mcpvault";
  version = "0.17.1";
in
buildNpmPackage {
  inherit pname version;
  src = fetchurl {
    url = "https://registry.npmjs.org/@bitbonsai/mcpvault/-/mcpvault-${version}.tgz";
    sha256 = "sha256-zkIsT5u/VwJj9RocfhK+FIvTWvnNVPspQHdJhKV3mPU=";
  };

  dontNpmBuild = true;
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';
  npmDepsHash = "sha256-obpq6HgHnHOCrsSrYEU5Yt/2BAHIzt7ruZv6weJUEnQ=";

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
