{
  pkgSource,
  lib,
  buildNpmPackage,
}:
buildNpmPackage {
  inherit (pkgSource) pname src;
  version = lib.removePrefix "v" pkgSource.version;

  npmDepsHash = "sha256-nyenuxsKRAL0PU/UPSJsz8ftHIF+LBTGdygTqxti38g=";

  meta = with lib; {
    description = "A centralized manager for Model Context Protocol (MCP) servers with dynamic server management and monitoring";
    homepage = "https://github.com/ravitemer/mcp-hub";
    license = licenses.mit;
    mainProgram = "mcp-hub";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
