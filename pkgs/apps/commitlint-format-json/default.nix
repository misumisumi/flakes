{
  pkgSource,
  lib,
  buildNpmPackage,
  importNpmLock,
}:
buildNpmPackage rec {
  inherit (pkgSource) pname src;
  version = lib.removePrefix "v" pkgSource.version;

  sourceRoot = "${src.name}/packages/json";

  npmDeps =
    let
      inherit (builtins) fromJSON readFile replaceStrings;
      pkgJSON = (fromJSON (readFile ../_sources/generated.json)).${pkgSource.pname};
      sha256 = replaceStrings [ "/" ] [ "_" ] "${pkgJSON.src.sha256}";
    in
    importNpmLock {
      npmRoot = ../_sources + "/${sha256}" + "/packages/json";
    };

  inherit (importNpmLock) npmConfigHook;
  dontNpmBuild = true;
  postInstall = ''
    cp -r src $out/lib/node_modules/${pname}/lib
  '';

  meta = with lib; {
    homepage = "https://github.com/bycedric/commitlint-formats";
    description = "Extra formatters for commitlint";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
