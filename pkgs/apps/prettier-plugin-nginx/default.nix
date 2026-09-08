{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
}:
let
  inherit (lib) licenses;
  pname = "prettier-plugin-nginx";
  version = "0-unstable-2026-09-04";
in
buildNpmPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "jxddk";
    repo = pname;
    rev = "f537ba5685806a6e7e4aacf33e1270041c885364";
    sha256 = "sha256-sXG9rBURaY69O1DalvsULuAJeyNcdBPyv1Q45BVLwS8=";
  };

  npmDepsHash = "sha256-PaSaHDJH6L1w7ZElqVln98KloemejMPx9zc22mX9uAQ=";
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version"
      "branch"
      "--generate-lockfile"
    ];
  };

  meta = {
    homepage = "https://github.com/jxddk/prettier-plugin-nginx";
    description = "NGINX configuration plugin for Prettier";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
