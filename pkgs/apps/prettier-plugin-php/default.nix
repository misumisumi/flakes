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
  version = "0.25.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-php";
  inherit version;
  src = fetchFromGitHub {
    owner = "prettier";
    repo = "plugin-php";
    rev = "v${version}";
    sha256 = "sha256-N/sDAV+u9h6cpxE5lstnp/FUzNHTXVR4GPyvckVrhus=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
  ];
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Of6OwyhVkhnGWGP++Es9/U3Z69it71Lu3E8DQNwC+eE=";
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
