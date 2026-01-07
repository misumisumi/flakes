{
  lib,
  name,
  pkgSources,
  buildPythonPackage,
  rustPlatform,
  rustc,
  rustfmt,
  stdenv,
}:
buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;
  pyproject = true;
  # for runtime depend
  cargoDeps = rustPlatform.importCargoLock {
    inherit (pkgSources."${name}".cargoLock."Cargo.lock") lockFile;
  };
  env = {
    CC = "${rustc.llvmPackages.clang}/bin/clang";
    CXX = "${rustc.llvmPackages.clang}/bin/clang++";
    RUSTFLAGS =
      let
        flags4linux = "-Clinker-plugin-lto -Clink-arg=-fuse-ld=${rustc.llvmPackages.lld}/bin/ld.lld -Clinker=${rustc.llvmPackages.clang}/bin/clang";
        flags4darwin = "-C link-arg=-fuse-ld=${rustc.llvmPackages.lld}/bin/ld64.lld -Clinker=./macos-linker.sh";
      in
      if stdenv.hostPlatform.isDarwin then flags4darwin else flags4linux;
  };
  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustfmt
  ];
  # build-system = [ rustPlatform.maturinBuildHook ];
  build-system = [
    rustPlatform.cargoSetupHook
    (rustPlatform.maturinBuildHook.overrideAttrs (old: {
      setEnv = lib.concatStringsSep " " [
        "CC=${rustc.llvmPackages.clang}/bin/clang"
        "CXX=${rustc.llvmPackages.clang}/bin/clang++"
      ];
    }))
  ];

  meta = with lib; {
    homepage = "https://github.com/rocksdict/RocksDict/tree/main";
    description = "Python fast on-disk dictionary / RocksDB & SpeeDB Python binding";
    license = licenses.mit;
    platforms = lib.platforms.all;
  };
}
