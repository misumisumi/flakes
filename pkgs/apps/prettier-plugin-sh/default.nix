{
  lib,
  fetchurl,
  nix-update-script,
  buildNpmPackage,
  importNpmLock,
}:
let
  inherit (lib) licenses;
  pname = "prettier-plugin-sh";
  version = "0.18.1";
in
buildNpmPackage {
  inherit pname version;
  src = fetchurl {
    url = "https://registry.npmjs.org/prettier-plugin-sh/-/prettier-plugin-sh-${version}.tgz";
    sha256 = "sha256-moAaaxeGJrqe4l/mg/rh2mpm93SXQj1wXD19hUu6cPA=";
  };

  npmDeps = importNpmLock {
    npmRoot = ./package-lock.json;
  };
  inherit (importNpmLock) npmConfigHook;

  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--generate-lockfile"
      "--version-regex"
      "prettier-plugin-sh@(*)"
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
