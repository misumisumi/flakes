{
  lib,
  packages,
  nix-update,
  python3,
  writeShellScriptBin,
}:
let
  inherit (builtins) hasAttr;
  inherit (lib)
    concatStringsSep
    filterAttrs
    mapAttrsToList
    ;
  app = writeShellScriptBin "update-pkgs" ''
    set -euo pipefail

    ${concatStringsSep "\n" (
      mapAttrsToList (pname: value: ''
        echo "Updating ${pname}..."
        ${nix-update}/bin/nix-update --flake ${pname} --use-update-script "$@"
      '') (filterAttrs (n: v: !(v.passthru.skipUpdate or false) && (hasAttr "src" v)) packages)
    )}
  '';
in

{
  type = "app";
  program = "${app}/bin/update-pkgs";
  meta.description = "Update packages in this flake.";
}
