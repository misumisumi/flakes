{
  name,
  lib,
  python3Packages,
  pkgSources,
}:
let
  inherit (python3Packages) buildPythonApplication;
in
buildPythonApplication {
  inherit (pkgSources."${name}") pname version src;
  pyproject = true;

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    beautifulsoup4
    fastmcp
    feedparser
    lxml
    mcp
    pypdf2
    requests
  ];

  pythonRelaxDeps = [ "fastmcp" ];

  pythonImportsCheck = [ "paper_search_mcp" ];
  fixupPhase = ''
    runHook preFixup

    runHook postFixup
  '';
  postFixup = ''

    mkdir -p $out/bin
    cat <<EOF > $out/bin/paper-search-mcp
    PYTHONPATH=$PYTHONPATH ${python3Packages.python.interpreter} -m paper_search_mcp.server
    EOF
    chmod +x $out/bin/paper-search-mcp

  '';

  meta = with lib; {
    homepage = "https://github.com/openags/paper-search-mcp";
    description = "A MCP for searching and downloading academic papers from multiple sources like arXiv, PubMed, bioRxiv, etc.";
    license = licenses.mit;
  };
}
