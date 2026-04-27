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
  version = "3b7610e168278483967b659f0d6668e8e6429cf1";
  src = fetchFromGitHub {
    owner = "misumisumi";
    repo = "paper-search-mcp";
    rev = "3b7610e168278483967b659f0d6668e8e6429cf1";
    fetchSubmodules = false;
    sha256 = "sha256-M8+GdY+Tnsf+ujZEZHDJ4Z0ueneeG4oy3Md1bzketEE=";
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
