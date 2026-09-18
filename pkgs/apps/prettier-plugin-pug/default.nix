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
  version = "3.5.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-pug";
  inherit version;
  src = fetchFromGitHub {
    owner = "prettier";
    repo = "plugin-pug";
    rev = version;
    sha256 = "sha256-TFVK2zmGmTCSdTdg15bbnMZTr7xRXr33hrSxrfDL/D4=";
  };

  nativeBuildInputs = [
    nodejs # in case scripts are run outside of a pnpm call
    pnpmConfigHook
    pnpm # At least required by pnpmConfigHook, if not other (custom) phases
    npmHooks.npmInstallHook
  ];

  dontNpmPrune = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    fetcherVersion = 4;
    hash = "sha256-7m2Bi110eAzBIOPixwkB7/tyaIQT6kCfArDdyUHOUZQ=";
  };

  meta = {
    homepage = "https://github.com/prettier/plugin-pug";
    description = "Prettier Pug Plugin";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      # "aarch64-darwin" #NOTE: due to https://github.com/NixOS/nixpkgs/issues/525627
    ];
  };
})
