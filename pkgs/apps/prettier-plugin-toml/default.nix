{
  lib,
  fetchurl,
  nix-update-script,
  buildNpmPackage,
}:
let
  inherit (lib) licenses;
  pname = "prettier-plugin-toml";
  version = "4.1.0";
in
buildNpmPackage {
  inherit pname version;
  src = fetchurl {
    url = "https://registry.npmjs.org/prettier-plugin-toml/-/prettier-plugin-toml-${version}.tgz";
    sha256 = "sha256-Qb4yFgh4kMwLh5TyXwxauG6TKM2jukT4lTmupwmjV9A=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-ov0q80mmuSkzFqXbjVlKMC7J0FWkg4QzlQhMeBZa3bw=";
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
