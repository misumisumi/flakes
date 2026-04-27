{
  lib,
  fetchurl,
  nix-update-script,
  buildNpmPackage,
  importNpmLock,
}:
let
  inherit (lib) licenses;
  pname = "prettier-plugin-sql";
  version = "0.20.0";
in
buildNpmPackage {
  inherit pname version;
  src = fetchurl {
    url = "https://registry.npmjs.org/prettier-plugin-sql/-/prettier-plugin-sql-${version}.tgz";
    sha256 = "sha256-2RSzk9YnUHovc1GAJu360W3VeEyaUEEh9fT9RqZgFNA=";
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
