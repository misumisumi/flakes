{
  lib,
  fetchurl,
  nix-update-script,
  buildNpmPackage,
  importNpmLock,
}:
let
  inherit (lib) licenses;
  pname = "prettier-plugin-toml";
  version = "1.0.6";
in
buildNpmPackage {
  inherit pname version;
  src = fetchurl {
    url = "https://registry.npmjs.org/prettier-plugin-toml/-/prettier-plugin-toml-${version}.tgz";
    sha256 = "sha256-TSG3iCwXcOjxbar7zWtey+JU9XPoSrenDOtU1abCo20=";
  };

  npmDeps = importNpmLock {
    npmRoot = ./package-lock.json;
  };
  inherit (importNpmLock) npmConfigHook;

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--generate-lockfile"
    ];
  };

  meta = {
    homepage = "https://github.com/un-ts/prettier";
    description = "Opinionated but Incredible Prettier plugins.";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
