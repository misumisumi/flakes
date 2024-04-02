{ final, prev }:
with builtins;
let
  inherit (prev) lib;
  files = readDir ./.;
  overridePkgs = lib.filterAttrs (path: type: type == "regular" && baseNameOf path != "default.nix") files;
in
lib.mapAttrs' (path: _: lib.nameValuePair (lib.removeSuffix ".nix" (baseNameOf path)) (import ./${path} { inherit final prev; })) overridePkgs
