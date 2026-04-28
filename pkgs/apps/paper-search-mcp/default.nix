{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:
let
  inherit (python3Packages) buildPythonApplication;
in
buildPythonApplication {
  pname = "paper-search-mcp";
  version = "0.1.3-unstable-2026-04-27";
  src = fetchFromGitHub {
    owner = "openags";
    repo = "paper-search-mcp";
    rev = "d499d014db0cfe4b76328716788e5fb12fb80eed";
    sha256 = "sha256-Q5kHDYawheAuRAzzChN9WGzDWMZOpDR76XmI7WVE3oQ=";
  };
  pyproject = true;

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    beautifulsoup4
    fastmcp
    feedparser
    lxml
    mcp
    pypdf
    requests
  ];

  pythonRelaxDeps = [ "fastmcp" ];

  pythonImportsCheck = [
    "paper_search_mcp"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version"
      "branch"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/openags/paper-search-mcp";
    description = "A MCP for searching and downloading academic papers from multiple sources like arXiv, PubMed, bioRxiv, etc.";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
