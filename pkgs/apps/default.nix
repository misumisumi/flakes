{
  lib,
  pkgs,
}:
let
  inherit (builtins) head;
  inherit (lib) mapAttrs splitString;
  inherit (pkgs)
    callPackage
    python3
    fetchgit
    fetchurl
    fetchFromGitHub
    dockerTools
    qemu
    OVMF
    buildPackages
    anti-anti-cheat-patch
    ;
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
  pkgSources = getSources ./_sources/generated.nix // {
    nixos-diff = { };
    ppp-scripts = { };
    skk-kaomoji-jisyo = { };
    yaskkserv2-dict = { };
  };

  cupsBrotherHll5100dnArgs = {
    lprdebSource = pkgSources.cups-brother-hll5100dn-lpr;
    cupsdebSource = pkgSources.cups-brother-hll5100dn-cupswrapper;
  };

  overrideArgs =
    pkgValue: pkgFunc:
    # Replace attr values when existing in pkgFunc args, otherwise keep pkgFunc args
    # Nothing do when attr values is not in pkgFunc args
    builtins.intersectAttrs (builtins.functionArgs pkgFunc) (
      {
        pkgSource = pkgValue;
        pythonPackages = python3.pkgs;
      }
      // cupsBrotherHll5100dnArgs
    );
  callPkgs =
    name: value:
    let
      path = ./${value.drvDir or (head (splitString "_" name))};
    in
    callPackage path (overrideArgs value (import path));
  prettierPlugins = import ./prettier-plugins {
    inherit
      lib
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      callPackage
      ;
  };
  aacPkgs = import ./aac-edk2-qemu {
    inherit
      OVMF
      anti-anti-cheat-patch
      buildPackages
      qemu
      ;
  };
in
rec {
  override = (withContents pkgSources callPkgs) // prettierPlugins // aacPkgs;
  packages = nixpkgs: mapAttrs (n: v: nixpkgs.${n}) override;
}
