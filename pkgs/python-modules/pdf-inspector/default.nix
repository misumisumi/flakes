{
  lib,
  buildPythonPackage,
  fetchPypi,
  cargo,
  rustc,
  rustPlatform,
  maturin,
  oniguruma,
  pkg-config,
}:

buildPythonPackage rec {
  pname = "pdf-inspector";
  version = "1.27.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pdf_inspector";
    inherit version;
    hash = "sha256-nMZTZkZeoWBAOSfXamq/G5gNcz7LZFMednmpLS506rA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-cYes6YqhWWb+QzMB96OvdQYaXSm3Oty7mzkUHFmBQyg=";
  };

  build-system = [
    maturin
  ];

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [ oniguruma ];

  env.RUSTONIG_SYSTEM_LIBONIG = true;

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
