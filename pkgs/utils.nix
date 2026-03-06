{
  lib,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  ...
}:
let
  inherit (builtins) fromJSON readFile;
  inherit (lib)
    nameValuePair
    mapAttrs'
    ;
in
{
  getSources =
    path:
    import path {
      inherit
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    };
  getSourcesJSON = path: fromJSON (readFile path);
  # [{name=<name>; value=func <name>;}] -> { <name> = func <name> <value>; }
  withContents = src: func: mapAttrs' (n: v: nameValuePair (v.drvDir or n) (func n v)) src;
}
