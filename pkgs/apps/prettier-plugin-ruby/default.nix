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
  version = "4.0.4";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-ruby";
  inherit version;
  src = fetchFromGitHub {
    owner = "prettier";
    repo = "plugin-ruby";
    rev = "v${version}";
    sha256 = "sha256-gEgs2L7q6WX/Cwtf4hsFzKZeJs2oXBckfQxINq2/Ahg=";
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
    hash = "sha256-KG6LwkBN3Ao85mIt244SNzOsLNxYM/g9meWJ5AknHis=";
  };

  meta = {
    homepage = "https://github.com/prettier/plugin-ruby";
    description = "Prettier Ruby Plugin";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
