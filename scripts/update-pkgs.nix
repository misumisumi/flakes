{
  lib,
  packages,
  nix-update,
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
      mapAttrsToList (
        pname: value:
        let
          useScript =
            if (hasAttr "updateScript" value.passthru) && (value.passthru.useUpdateScript or true) then
              "--use-update-script"
            else
              "";
        in
        ''
          echo "Updating ${pname}..."
          ${nix-update}/bin/nix-update ${pname} --flake ${useScript} "$@"
        ''
      ) (filterAttrs (n: v: !(v.passthru.skipUpdate or false) && (hasAttr "src" v)) packages)
    )}
  '';
in

{
  type = "app";
  program = "${app}/bin/update-pkgs";
  meta.description = "Update packages in this flake.";
}
