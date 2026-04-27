{
  lib,
  python3,
  ...
}:
let
  inherit (builtins)
    functionArgs
    intersectAttrs
    ;
  inherit (lib) listToAttrs nameValuePair;
in
{
  overrideArgs =
    pkgValue: pkgFunc:
    # Replace attr values when existing in pkgFunc args, otherwise keep pkgFunc args
    # Nothing do when attr values is not in pkgFunc args
    intersectAttrs (functionArgs pkgFunc) {
      pythonPackages = python3.pkgs;
    };
  # [{name=<name>; value=func <name>;}] -> { <name> = func <name> <value>; }
  withContents = srcs: func: listToAttrs (map (n: nameValuePair n (func n)) srcs);
}
