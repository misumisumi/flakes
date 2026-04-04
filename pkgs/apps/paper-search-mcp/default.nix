{
  pkgSource,
  lib,
  python3Packages,
  fetchFromGitHub,
}:
let
  inherit (python3Packages) buildPythonApplication;
in
buildPythonApplication {
  inherit (pkgSource) pname src;
  version = pkgSource.date;
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

  meta = with lib; {
    homepage = "https://github.com/openags/paper-search-mcp";
    description = "A MCP for searching and downloading academic papers from multiple sources like arXiv, PubMed, bioRxiv, etc.";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
