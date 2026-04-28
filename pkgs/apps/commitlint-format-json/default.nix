{
  lib,
  fetchurl,
  nix-update-script,
  buildNpmPackage,
}:
buildNpmPackage {
  pname = "commitlint-format-json";
  version = "1.1.0";
  src = fetchurl {
    url = "https://registry.npmjs.org/commitlint-format-json/-/commitlint-format-json-1.1.0.tgz";
    sha256 = "sha256-VyY0HOpelsy7s96i1aI5Vl9Y63tUoa6cO6oT6bHu1uk=";
  };
  dontNpmBuild = true;

  npmDepsHash = "sha256-wr//XWfRoq/NJYxzMYcNlHWA9INncyhiNTeqN1fsRZs=";
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--generate-lockfile"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/bycedric/commitlint-formats";
    description = "Extra formatters for commitlint";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
