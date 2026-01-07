{
  lib,
  name,
  pkgSources,
  buildPythonPackage,
  rustPlatform,
  anyio,
  protobuf,
  sniffio,
}:
buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;
  pyproject = true;
  # for runtime depend
  cargoDeps = rustPlatform.importCargoLock {
    inherit (pkgSources."${name}".cargoLock."Cargo.lock") lockFile;
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
  # build-system = [ rustPlatform.maturinBuildHook ];
  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  meta = with lib; {
    homepage = "https://github.com/valkey-io/valkey-glide";
    description = "An open source Valkey client library";
    license = licenses.asl20;
    platforms = lib.platforms.all;
  };
}
