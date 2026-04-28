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
  version = "3.4.1";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-ruby";
  inherit version;
  src = fetchFromGitHub {
    owner = "prettier";
    repo = "plugin-xml";
    rev = "v${version}";
    sha256 = "sha256-7/0a00fdDso8yZyFkrBUwA2uxlN/pifSrKHGDjJS5Y0=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
  ];

  dontYarnBuild = true;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-VRUnlE8AQQJfPTMdexPZ/5jPFtU/qSV5GFM0pSLH9zI=";
  };

  meta = {
    homepage = "https://github.com/prettier/plugin-xml";
    description = "Prettier XML Plugin";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
