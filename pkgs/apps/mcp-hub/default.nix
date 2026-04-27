{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
let
  pname = "mcp-hub";
  version = "4.2.1";
in
buildNpmPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "ravitemer";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-KakvXZf0vjdqzyT+LsAKHEr4GLICGXPmxl1hZ3tI7Yg=";
  };

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
