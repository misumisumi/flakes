{
  pkgSource,
  lib,
  fetchPnpmDeps,
  nodejs,
  npmHooks,
  pnpm,
  pnpmConfigHook,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit (pkgSource) pname src;
  version = lib.removePrefix "v" pkgSource.version;

  nativeBuildInputs = [
    nodejs # in case scripts are run outside of a pnpm call
    pnpmConfigHook
    pnpm # At least required by pnpmConfigHook, if not other (custom) phases
    npmHooks.npmInstallHook
  ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-BuTKNAC/fLWCMNgg1pn9jiUeK7WVgoaMzPQV/AA9EQE=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "git config --local core.hooksPath .githooks" ""
  '';

  buildPhase = ''
    runHook preBuild

    npx tsc --build

    runHook postBuild
  '';

  npmFlags = [ "--legacy-peer-deps" ];
  dontNpmPrune = true;

  meta = with lib; {
    description = "A CLI that update GitHub Actions's `permissions` automatically";
    homepage = "https://github.com/pkgdeps/update-github-actions-permissions";
    license = with licenses; [
      mit
      agpl3Plus
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
