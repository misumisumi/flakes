{
  lib,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  python3,
}:
let
  inherit (builtins) head;
  inherit (lib) mapAttrs splitString;
  inherit
    (import ../utils.nix {
      inherit lib;
      inherit
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    getSources
    withContents
    ;
  pkgSources = getSources ./_sources/generated.nix;

  overrideArgs =
    pkgValue: pkgFunc:
    builtins.intersectAttrs (builtins.functionArgs pkgFunc) {
      pkgSource = pkgValue;
      pythonPackages = python3.pkgs;
    };
  callPkgs =
    name: value:
    let
      name' = value.name or (head (splitString "_" name));
      path = ./${name'};
    in
    python3.pkgs.callPackage path (overrideArgs value (import path));
in
rec {
  override = withContents pkgSources callPkgs;
  packages = nixpkgs: mapAttrs (n: v: nixpkgs.python3.pkgs.${n}) override;
}
