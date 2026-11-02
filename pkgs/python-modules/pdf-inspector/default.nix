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
  version = "1.25.2";
  pyproject = true;

  src = fetchPypi {
    pname = "pdf_inspector";
    inherit version;
    hash = "sha256-InU365HIr7zZlcOG/14QaDKG87RObTheFDMEJV9y7pI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-7VREdpt2S3o3VhA/vJT+vxaRPXSYJlZG9VNxX9zS/ms=";
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
