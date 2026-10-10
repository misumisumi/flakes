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
  version = "0.1.4-unstable-2026-10-02";
  src = fetchFromGitHub {
    owner = "openags";
    repo = "paper-search-mcp";
    rev = "cab1b5cc276a0cd004a0044003926a6440088049";
    sha256 = "sha256-KyAGr1CuBsJeM+H4Ex5knD1fL0A1h7yKO9qVO7fDiIg=";
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
