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
  version = "0.1.3-unstable-2026-05-18";
  src = fetchFromGitHub {
    owner = "openags";
    repo = "paper-search-mcp";
    rev = "d438222d3e30e4721c9fa721d4275bda681a9117";
    sha256 = "sha256-3grIU9xbI7AnBhth3u69YeYcxAeM/aD55Ur1fDEJSng=";
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
