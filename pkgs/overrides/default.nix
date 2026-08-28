{ final, prev }:
with builtins;
let
  inherit (prev) lib;
  files = readDir ./.;
  overridePkgs = lib.filterAttrs (
    path: type: type == "regular" && baseNameOf path != "default.nix"
  ) files;
in
(lib.mapAttrs' (
  path: _:
  lib.nameValuePair (lib.removeSuffix ".nix" (baseNameOf path)) (
    import ./${path} { inherit final prev; }
  )
) overridePkgs)
// {
  #NOTE: https://codeberg.org/Scrut1ny/AutoVirt not support QEMU 11.0.3 or later
  qemu = prev.qemu.overrideAttrs (old: rec {
    version = "11.0.2";
    src = prev.fetchurl {
      url = "https://download.qemu.org/qemu-${version}.tar.xz";
      hash = "sha256-N0X26oji6H/g3IOLKx1OCncL9I4BodWhhoQqH/92zPU=";
    };
    enableParallelBuilding = true;
  });
}
