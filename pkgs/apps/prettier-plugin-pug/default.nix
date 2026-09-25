{
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  npmHooks,
  pnpm_12,
  pnpmConfigHook,
  stdenv,
  nix-update-script,
}:
let
  inherit (lib) licenses;
  version = "3.5.0";
  pnpm = pnpm_12;
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

  npmFlags = [
    # package.json declares `devEngines.packageManager` as pnpm, which makes
    # `npm pack` abort with EBADDEVENGINES. `--force` is the only way to skip
    # that check.
    "--force"
  ];
  dontNpmPrune = true;

  # The plugin entrypoint is `dist/index.js`, which is produced by tsup and is
  # not part of the repository. `build:code` is used instead of `build` because
  # the latter runs `git clean` which fails in a Nix sandbox.
  buildPhase = ''
    runHook preBuild

    pnpm run build:code

    runHook postBuild
  '';

  postInstall = ''
    # pnpm writes absolute build paths and a timestamp into its metadata, which
    # makes the output non-deterministic. See https://github.com/pnpm/pnpm/issues/3645
    find "$out" -name .modules.yaml -delete
    find "$out" -name .pnpm-workspace-state-v1.json -delete
    # pnpm's symlinks into the store dangle once the output is copied.
    find "$out" -xtype l -delete
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-XuHinYGsG9Roujmt8uJaDbbfKYfTa/XPAi7itFskbX0=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
    ];
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
