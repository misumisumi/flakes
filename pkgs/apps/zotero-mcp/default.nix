{
  lib,
  fetchFromGitHub,
  nix-update,
  writeShellScript,
  python3Packages,
  rustPlatform,
}:
let
  inherit (python3Packages) buildPythonApplication;

  # Upstream pins pdf-inspector==0.2.6, so keep using that version here even
  # though the overlay provides a newer one.
  pdf-inspector = python3Packages.pdf-inspector.overridePythonAttrs (old: rec {
    version = "0.2.6";
    src = python3Packages.fetchPypi {
      pname = "pdf_inspector";
      inherit version;
      hash = "sha256-W7OH85v3qTsCtJGItnC5eY+MzH5Y9o7uWIOlEqoFzrI=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (old) pname;
      inherit version src;
      hash = "sha256-/PTqpmL2JdnK/Ejo3IAK/DqTSVrA9zTmFnmRPoc4tLc=";
    };
  });

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
  version = "0.17.1";
  src = fetchFromGitHub {
    owner = "54yyyu";
    repo = "zotero-mcp";
    tag = "v${version}";
    hash = "sha256-dVOBF8e9r6bbyQnpEIsIfe98nD6P21BAQENq4d6oZtA=";
  };
  pyproject = true;

  build-system = with python3Packages; [ hatchling ];

  dependencies = [
    pyzotero
    pdf-inspector
  ]
  ++ (with python3Packages; [
    bibtexparser
    fastmcp
    httpx
    markdown-it-py
    markdownify
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
