{
  lib,
  buildPythonPackage,
  fetchurl,
  cargo,
  rustc,
  rustPlatform,
  maturin,
}:

buildPythonPackage rec {
  pname = "pdf-inspector";
  version = "0.2.6";
  pyproject = true;

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/8d/7a/525ee06cad5c46d8aa7357c15b8f72c60e803246f3b7e24523e602f01f6d/pdf_inspector-${version}.tar.gz";
    hash = "sha256-W7OH85v3qTsCtJGItnC5eY+MzH5Y9o7uWIOlEqoFzrI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-/PTqpmL2JdnK/Ejo3IAK/DqTSVrA9zTmFnmRPoc4tLc=";
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

  meta = {
    description = "Fast PDF inspection, classification, and text extraction";
    homepage = "https://github.com/firecrawl/pdf-inspector";
    license = lib.licenses.mit;
  };
}
