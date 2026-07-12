{
  lib,
  fetchurl,
  nix-update-script,
  buildNpmPackage,
}:
let
  inherit (lib) licenses;
  pname = "prettier-plugin-sh";
  version = "0.19.0";
in
buildNpmPackage {
  inherit pname version;
  src = fetchurl {
    url = "https://registry.npmjs.org/prettier-plugin-sh/-/prettier-plugin-sh-${version}.tgz";
    sha256 = "sha256-406FOQ1cZ9j05UstQfKsff7I3yGn43ZYka9WOJkVQhc=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-Rr4bWzcFicOvYqJbPAH9vvcxgMhreRtTRTbG0GeyRYM=";
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
