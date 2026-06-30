{
  lib,
  fetchPypi,
  buildPythonPackage,
  rustPlatform,
  anyio,
  protobuf,
  sniffio,
}:
let
  pname = "valkey-glide";
  version = "2.4.2";
  src = fetchPypi {
    pname = "valkey_glide";
    inherit version;
    sha256 = "sha256-1jp0g8LbWdjHNmajYCRsrarIK21xCH11g5OV/6z4Y+A=";
  };
in
buildPythonPackage {
  inherit pname version src;

  doCheck = false;
  pyproject = true;
  # for runtime depend
  # cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-dxb8c00tYitsBwArat3ETc1pz4jnCGZBKj5jbmDzVY4=";
  };

  dependencies = [
    anyio
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

  passthru.useUpdateScript = false;

  meta = with lib; {
    homepage = "https://github.com/valkey-io/valkey-glide";
    description = "An open source Valkey client library";
    license = licenses.asl20;
    platforms = lib.platforms.all;
  };
}
