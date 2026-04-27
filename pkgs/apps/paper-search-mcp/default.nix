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
  version = "6d1f7ef5bcb7cfa5905d50c42fd7b8a4c1c16afd";
  src = fetchFromGitHub {
    owner = "misumisumi";
    repo = "paper-search-mcp";
    rev = "6d1f7ef5bcb7cfa5905d50c42fd7b8a4c1c16afd";
    fetchSubmodules = false;
    sha256 = "sha256-P7PFynx+BZ/LuxXRjkuWhlqiYVm1+3UugFin3Qu7rmM=";
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
