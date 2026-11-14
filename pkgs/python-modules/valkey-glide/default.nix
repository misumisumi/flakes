{
  lib,
  fetchPypi,
  buildPythonPackage,
  pkgs,
  pkg-config,
  rustPlatform,
  anyio,
  aws-lc,
  cffi,
  protobuf,
  sniffio,
}:
let
  pname = "valkey-glide";
  version = "2.6.0";
  # Since 2.6.0 the sdist keeps the crate in a subdirectory.
  cargoRoot = "python/glide-async";
  src = fetchPypi {
    pname = "valkey_glide";
    inherit version;
    sha256 = "sha256-a72FDPWZQ7d8dWdXnhqcdNzJcvjry+gTOrvAaeRAFmc=";
  };
in
buildPythonPackage {
  inherit pname version src cargoRoot;

  doCheck = false;
  pyproject = true;
  # NOTE: The PyPI sdist does not ship `glide_shared`, `libglide_ffi.so`
  # and `_fast_response`, so the resulting package cannot `import glide`.
  # Upstream issue: https://github.com/valkey-io/valkey-glide/issues/4884
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src cargoRoot;
    hash = "sha256-awwyYKWqocaYLTEsgg3OePJ+Fje9i2ot4Z2VxYvaPnA=";
  };

  dependencies = [
    anyio
    cffi
    protobuf
    sniffio
  ];
  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace-fail "maturin==0.14.17" "maturin"
  '';
  build-system = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    pkgs.zstd.dev
  ];

  env.AWS_LC_SYS_USE_SYSTEM = true;

  passthru.useUpdateScript = false;

  meta = with lib; {
    homepage = "https://github.com/valkey-io/valkey-glide";
    description = "An open source Valkey client library";
    license = licenses.asl20;
    platforms = lib.platforms.all;
  };
}
