{
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  npmHooks,
  pnpm,
  pnpmConfigHook,
  stdenv,
}:
let
  pname = "update-github-actions-permissions";
  version = "2.9.1";
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "pkgdeps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qkot1TKnc7Hn825xNOtFS0Lu/zdCgw6GowLE05gap48=";
  };

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
