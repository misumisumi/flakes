{
  lib,
  packages,
  nix-update,
  writeShellScriptBin,
  hashOnly ? false,
}:
let
  inherit (builtins)
    any
    hasAttr
    ;
  inherit (lib)
    concatStringsSep
    filterAttrs
    mapAttrsToList
    ;

  dependencyHashAttrs = [
    "cargoDeps"
    "composerVendor"
    "fetchedMavenDeps"
    "go-modules"
    "goModules"
    "mixFodDeps"
    "npmDeps"
    "nugetDeps"
    "offlineCache"
    "pnpmDeps"
    "yarnOfflineCache"
    "zigDeps"
  ];

  hasDependencyHash = value: any (attr: (value.${attr} or null) != null) dependencyHashAttrs;

  selectedPackages = filterAttrs (
    n: v:
    !(v.passthru.skipUpdate or false)
    && hasAttr "src" v
    && (!hashOnly || hasDependencyHash v)
  ) packages;

  scriptName = if hashOnly then "update-pkgs-hashes" else "update-pkgs";

  app = writeShellScriptBin scriptName ''
    set -euo pipefail

    ${concatStringsSep "\n" (
      mapAttrsToList (
        pname: value:
        let
          useScript =
            if
              !hashOnly
              && (hasAttr "updateScript" value.passthru)
              && (value.passthru.useUpdateScript or true)
            then
              "--use-update-script"
            else
              "";
          hashArgs = if hashOnly then "--version skip --no-src" else "";
        in
        ''
          echo "Updating ${pname}..."
          ${nix-update}/bin/nix-update ${pname} --flake ${useScript} ${hashArgs} "$@"
        ''
      ) selectedPackages
    )}
  '';
in
{
  type = "app";
  program = "${app}/bin/${scriptName}";
  meta.description =
    if hashOnly then "Update dependency hashes of packages in flake." else "Update packages in flake.";
}
