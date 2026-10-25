{
  lib,
  fetchFromGitHub,
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
}:
let
  inherit (lib) licenses;
  version = "0.26.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-php";
  inherit version;
  src = fetchFromGitHub {
    owner = "prettier";
    repo = "plugin-php";
    rev = "v${version}";
    sha256 = "sha256-LKCABrYH9XUZniB44XZzgwCLv7WP+Snp1xJRk2FtPyc=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
  ];
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-tNm/5S0ruP59G/KAH4rIosns54x4XmpdIPL1TRTDR/I=";
  };

  meta = {
    homepage = "https://github.com/prettier/plugin-php";
    description = "Prettier PHP Plugin";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
