{
  lib,
  buildPythonPackage,
  fetchPypi,
  cargo,
  rustc,
  rustPlatform,
  maturin,
}:

buildPythonPackage rec {
  pname = "pdf-inspector";
  version = "1.26.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pdf_inspector";
    inherit version;
    hash = "sha256-DJZ3ah83Dlo1I3TLGK0cNl7tTgmf8A7weRLa1NfbiK4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-72L9SGxcFPmFulT6aEPWpj8fQS6hpJG29s45Et6DzDk=";
  };

  build-system = [
    maturin
  ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  doCheck = false;

  pythonImportsCheck = [ "pdf_inspector" ];

  # Use nix-update directly instead of the default update-python-libraries
  # script, which does not work with this flake.
  passthru.useUpdateScript = false;

  meta = {
    description = "Fast PDF inspection, classification, and text extraction";
    homepage = "https://github.com/firecrawl/pdf-inspector";
    license = lib.licenses.mit;
  };
}
