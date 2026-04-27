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
  version = "";
  src = fetchFromGitHub {
    owner = "bitbonsai";
    repo = pname;
    rev = "32776a5f7fd62526863618b10a85e086deb22db8";
    sha256 = "sha256-3VCFumEz61m3kat4ACkmlKaoACyB6g5NXlwZBaPG+Rc=";
  };

  npmDepsHash = "sha256-Wcp053R388YGd7sdWtIgJ/DdMkepx+4aymev8jDA/VE=";

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
