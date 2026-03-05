{
  lib,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  callPackage,
}:
let
  inherit (builtins) readFile fromJSON;
  inherit (lib)
    mapAttrs
    ;
  hashes = fromJSON (readFile ./hashes.json);
  pkgFunc =
    name: pkgSource:
    if pkgSource.pkgmgr == "npm" then
      callPackage ./npm.nix {
        inherit pkgSource;
        depsHash = hashes.${name} or "";
      }
    else if pkgSource.pkgmgr == "yarn" || pkgSource.pkgmgr == "yarn-berry" then
      callPackage ./yarn.nix {
        inherit pkgSource;
        depsHash = hashes.${name};
      }
    else if pkgSource.pkgmgr == "pnpm" then
      callPackage ./pnpm.nix {
        inherit pkgSource;
        depsHash = hashes.${name};
      }
    else
      throw "Unsupported package manager: ${pkgSource.pkgmgr}";
  generated = import ./_sources/generated.nix {
    inherit
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };
in
mapAttrs pkgFunc generated
