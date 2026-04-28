{
  lib,
  fetchurl,
  nix-update-script,
  buildNpmPackage,
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

  dontNpmBuild = true;

  npmDepsHash = "sha256-2iutb1mNmL8AoU38woNexhJT3VH5otLATc+UKG8NXco=";
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
