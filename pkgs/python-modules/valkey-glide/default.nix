{
  lib,
  fetchPypi,
  buildPythonPackage,
  rustPlatform,
  anyio,
  cffi,
  protobuf,
  sniffio,
}:
let
  pname = "valkey-glide";
  version = "2.5.1";
  src = fetchPypi {
    pname = "valkey_glide";
    inherit version;
    sha256 = "sha256-su+yPJh6mVrWzipyYWmWY4E33SUErCYr3WwEU3g5QJA=";
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
    hash = "sha256-lyWof2Ov/IDHT1ohQAKbVro5XoNsZWCONiXVEZz+6Wk=";
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

  passthru.useUpdateScript = false;

  meta = with lib; {
    homepage = "https://github.com/valkey-io/valkey-glide";
    description = "An open source Valkey client library";
    license = licenses.asl20;
    platforms = lib.platforms.all;
  };
}
