{
  lib,
  fetchurl,
  nix-update-script,
  buildNpmPackage,
}:
let
  inherit (lib) licenses;
  pname = "prettier-plugin-sh";
  version = "0.20.2";
in
buildNpmPackage {
  inherit pname version;
  src = fetchurl {
    url = "https://registry.npmjs.org/prettier-plugin-sh/-/prettier-plugin-sh-${version}.tgz";
    sha256 = "sha256-C+BmCxQpaYg52HycFNtPbikTg1erChUwYRELogVuhKU=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-FVqFFsVpNBKLgnHo+A9GCn9qvcC5MWDb+26FZ/1pipo=";
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
