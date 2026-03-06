{
  pkgSource,
  lib,
  fetchPnpmDeps,
  nodejs,
  npmHooks,
  pnpm,
  pnpmConfigHook,
  stdenv,
  depsHash ? lib.fakeHash,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit (pkgSource) pname src version;

  nativeBuildInputs = [
    nodejs # in case scripts are run outside of a pnpm call
    pnpmConfigHook
    pnpm # At least required by pnpmConfigHook, if not other (custom) phases
    npmHooks.npmInstallHook
  ];

  dontNpmPrune = pkgSource.dontNpmPrune or "no" == "yes";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = depsHash;
  };

  meta = with lib; {
    inherit version;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
