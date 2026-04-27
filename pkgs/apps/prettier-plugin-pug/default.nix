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
  inherit (lib) licenses;
  version = "3.4.2";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-pug";
  inherit version;
  src = fetchFromGitHub {
    owner = "prettier";
    repo = "plugin-pug";
    rev = version;
    sha256 = "sha256-4CsKMj8Xnq+dlGzLAG2hV8jTCMYBYhaV/uoKAfztSGs=";
  };

  nativeBuildInputs = [
    nodejs # in case scripts are run outside of a pnpm call
    pnpmConfigHook
    pnpm # At least required by pnpmConfigHook, if not other (custom) phases
    npmHooks.npmInstallHook
  ];

  dontNpmPrune = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-GZYSlK1B0pb6X7ldW4PZWHJOUvtUMysYJjoD/nsV3S0=";
  };

  meta = {
    homepage = "https://github.com/prettier/plugin-pug";
    description = "Prettier Pug Plugin";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
