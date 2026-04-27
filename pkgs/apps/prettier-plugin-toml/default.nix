{
  lib,
  fetchurl,
  nix-update-script,
  buildNpmPackage,
}:
let
  inherit (lib) licenses;
  pname = "prettier-plugin-toml";
  version = "2.0.6";
in
buildNpmPackage {
  inherit pname version;
  src = fetchurl {
    url = "https://registry.npmjs.org/prettier-plugin-toml/-/prettier-plugin-toml-${version}.tgz";
    sha256 = "sha256-TSG3iCwXcOjxbar7zWtey+JU9XPoSrenDOtU1abCo20=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-11tfR1NI16By7JzbmsO/NAOKH/H68vG2JjZpwT4ds/Q=";
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
