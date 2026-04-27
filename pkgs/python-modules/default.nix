{
  lib,
  pkgs,
}:
let
  inherit (builtins)
    all
    attrNames
    functionArgs
    head
    intersectAttrs
    readDir
    ;
  inherit (lib) filterAttrs mapAttrs splitString;

  inherit (pkgs)
    callPackage
    python3
    ;

  inherit (import ../utils.nix { inherit lib python3 callPackage; }) withContents;

  ignoreModules = [ ];
  modules = attrNames (
    filterAttrs (n: v: (all (p: n != p) ignoreModules) && (v == "directory")) (readDir ./.)
  );
  callPkgs =
    name:
    let
      path = ./${name};
    in
    python3.pkgs.callPackage path { };

in
rec {
  override = withContents modules callPkgs;
  packages = nixpkgs: mapAttrs (n: v: nixpkgs.python3.pkgs.${n}) override;
}
