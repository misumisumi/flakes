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
  version = "2.3.1";
  src = fetchPypi {
    pname = "valkey_glide";
    inherit version;
    sha256 = "sha256-9LrgMMCqblXtssJ9vVX4LPtfWBkE//ExjuwcBi8w1LM=";
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
    hash = "sha256-2P1bswmXCqsxjhcfZvRwlm1lOS+ByaXxBvmxz8fKJWY=";
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
