{
  pkgSource,
  lib,
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  yarn-berry,
  nodejs,
  depsHash ? lib.fakeHash,
}:
let
  inherit (builtins) fromJSON readFile;
  useBerry = pkgSource.pkgmgr == "yarn-berry";
in
stdenv.mkDerivation (
  finalAttrs:
  rec {
    inherit (pkgSource)
      pname
      version
      src
      ;

    nativeBuildInputs = [
      nodejs
    ]
    ++ (
      if useBerry then
        [
          yarn-berry
          yarn-berry.yarnBerryConfigHook
        ]
      else
        [
          yarnConfigHook
          yarnBuildHook
          yarnInstallHook
        ]
    );
    dontYarnBuild = pkgSource.dontYarnBuild or "no" == "yes";

    meta = {
      inherit version;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    };
  }
  // lib.optionalAttrs (pkgSource.sourceRoot or null != null) {
    sourceRoot = "${pkgSource.src.name}/${pkgSource.sourceRoot}";
  }
  // (
    if useBerry then
      let
        pkgJSON = (fromJSON (readFile ./_sources/generated.json)).${pkgSource.pname};
        sha256 = "${pkgJSON.src.sha256}";
      in
      {
        missingHashes = ./_sources + "/${sha256}" + "/missing-hashes.json";
        offlineCache = yarn-berry.fetchYarnBerryDeps {
          inherit (finalAttrs) src missingHashes;
          hash = depsHash;
        };
      }
    else
      {
        yarnOfflineCache = fetchYarnDeps {
          yarnLock = finalAttrs.src + "/yarn.lock";
          hash = depsHash;
        };
      }
  )
)
