{
  pkgSource,
  lib,
  buildNpmPackage,
  importNpmLock,
  depsHash ? lib.fakeHash,
}:
buildNpmPackage (
  {
    inherit (pkgSource) pname src;
    version = pkgSource.date or (lib.removePrefix "v" pkgSource.version);

    dontNpmBuild = pkgSource.dontNpmBuild or "no" == "yes";

    meta = with lib; {
      inherit version;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    };
  }
  // lib.optionalAttrs (pkgSource.needGenLock or "no" == "yes") {
    npmDeps =
      let
        inherit (builtins) fromJSON readFile replaceStrings;
        pkgJSON = (fromJSON (readFile ./_sources/generated.json)).${pkgSource.pname};
        sha256 = replaceStrings [ "/" ] [ "_" ] "${pkgJSON.src.sha256}";
      in
      importNpmLock {
        npmRoot = ./_sources + "/${sha256}";
      };
    inherit (importNpmLock) npmConfigHook;
  }
  // lib.optionalAttrs (pkgSource.needGeoLock or "no" == "no") {
    npmDepsHash = depsHash;
  }
)
