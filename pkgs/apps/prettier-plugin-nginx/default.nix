{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
}:
let
  inherit (lib) licenses;
  pname = "prettier-plugin-nginx";
  version = "0-unstable-2023-03-17";
in
buildNpmPackage {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "jxddk";
    repo = pname;
    rev = "b3c840f4bac1373c2dc984825e3dad3308fcbcbe";
    sha256 = "sha256-JsAgLg89gxLlmXbeoFAceGsmvLLrHuQHA/heuzFxWSg=";
  };

  npmDepsHash = "sha256-tE9czVsJEfQxLUPiifZll8sV2aGmfCO/uCAgOCKGU+Y=";
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
