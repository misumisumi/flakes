{
  lib,
  fetchPypi,
  nix-update-script,
  buildPythonPackage,
  rustPlatform,
  anyio,
  protobuf,
  sniffio,
}:
let
  version = "2.3.1";
in
buildPythonPackage {
  pname = "valkey-glide";
  inherit version;
  src = fetchPypi {
    pname = "valkey_glide";
    inherit version;
    sha256 = "sha256-9LrgMMCqblXtssJ9vVX4LPtfWBkE//ExjuwcBi8w1LM=";
  };

  doCheck = false;
  pyproject = true;
  # for runtime depend
  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

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
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--generate-lockfile"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/valkey-io/valkey-glide";
    description = "An open source Valkey client library";
    license = licenses.asl20;
    platforms = lib.platforms.all;
  };
}
