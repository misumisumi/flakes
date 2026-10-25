{
  lib,
  fetchFromGitHub,
  nix-update,
  writeShellScript,
  python3Packages,
}:
let
  inherit (python3Packages) buildPythonApplication;

  pyzotero = python3Packages.pyzotero.overridePythonAttrs (old: rec {
    version = "1.16.0";
    src = fetchFromGitHub {
      owner = "urschrei";
      repo = "pyzotero";
      tag = "v${version}";
      hash = "sha256-9iWBGu2VJb+lfDg2By2m2p4zC/4tOHatR5FBP86ntYs=";
    };
    dependencies = (old.dependencies or [ ]) ++ [ python3Packages.httpx2 ];
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail "uv_build>=0.8.14,<0.12.0" "uv-build"
    '';
    doCheck = false;
  });
in
buildPythonApplication rec {
  pname = "zotero-mcp";
  version = "0.15.1";
  src = fetchFromGitHub {
    owner = "54yyyu";
    repo = "zotero-mcp";
    tag = "v${version}";
    hash = "sha256-X4IfIVTp2DWCB5oCzgq8SCHUYjqOQEePq46RPKaQYyw=";
  };
  pyproject = true;

  build-system = with python3Packages; [ hatchling ];

  dependencies = [
    pyzotero
  ]
  ++ (with python3Packages; [
    bibtexparser
    fastmcp
    httpx
    markdown-it-py
    markdownify
    pdf-inspector
    pydantic
    python-dotenv
    requests
    unidecode
  ]);

  pythonImportsCheck = [ "zotero_mcp" ];

  passthru = {
    inherit pyzotero;

    updateScript = writeShellScript "update-zotero-mcp" ''
      set -euo pipefail
      ${lib.getExe nix-update} --flake --version stable "$UPDATE_NIX_ATTR_PATH"
      ${lib.getExe nix-update} --flake --version stable "$UPDATE_NIX_ATTR_PATH.pyzotero"
    '';
  };

  meta = with lib; {
    homepage = "https://github.com/54yyyu/zotero-mcp";
    description = "Zotero MCP server and CLI: chat with your Zotero research library in AI agents";
    license = with licenses; [
      mit
      agpl3Plus
    ];
    mainProgram = "zotero-mcp";
    platforms = platforms.all;
  };
}
