{
  lib,
  ...
}:
let
  inherit (builtins) any;
  inherit (lib)
    filterAttrs
    mapAttrs
    ;
  # From https://github.com/numtide/flake-utils
  mkApp =
    {
      drv,
      name ? drv.pname or drv.name,
      exePath ? drv.exePath or drv.meta.mainProgram or "/bin/${name}",
    }:
    {
      type = "app";
      program = "${drv}${exePath}";
    };
in
{
  mkApps = pkgs: mapAttrs (n: v: mkApp { drv = pkgs.${n}; }) pkgs;
  mkCheck = pkgs: filterAttrs (n: v: (!(v.meta.skipCheck or v.meta.broken or false))) pkgs;
  mkPackages =
    system: pkgs:
    filterAttrs (
      n: v: ((v.notPackage or "no") != "yes") && any (x: system == x) (v.meta.platforms or [ system ])
    ) pkgs;
}
