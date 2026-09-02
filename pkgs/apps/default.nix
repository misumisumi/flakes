{
  lib,
  pkgs,
}:
let
  inherit (builtins)
    all
    attrNames
    readDir
    ;
  inherit (lib) filterAttrs mapAttrs;
  inherit (pkgs)
    callPackage
    python3
    fetchgit
    fetchurl
    fetchFromGitHub
    dockerTools
    edk2
    qemu
    OVMF
    ;

  inherit (import ../utils.nix { inherit lib python3 callPackage; }) withContents;

  ignorePkgs = [
    "aac-edk2-qemu"
    "anti-anti-cheat-patch"
    "blender-bin"
  ];

  apps = attrNames (
    filterAttrs (n: v: (all (p: n != p) ignorePkgs) && (v == "directory")) (readDir ./.)
  );

  #NOTE: https://codeberg.org/Scrut1ny/AutoVirt not support QEMU=11.0.3, EDK2=202605 or later
  fixed-qemu = qemu.overrideAttrs (old: rec {
    version = "11.0.2";
    src = fetchurl {
      url = "https://download.qemu.org/qemu-${version}.tar.xz";
      hash = "sha256-N0X26oji6H/g3IOLKx1OCncL9I4BodWhhoQqH/92zPU=";
    };
    enableParallelBuilding = true;
  });
  fixed-edk2 = edk2.overrideAttrs (old: rec {
    version = "202605";
    srcWithVendoring = fetchFromGitHub {
      owner = "tianocore";
      repo = "edk2";
      tag = "edk2-stable${version}";
      fetchSubmodules = true;
      hash = "sha256-sUqLocdX7lxN2pEdn84Cjh8pOzYqIeKqO144XhwKA30=";
    };
    __intentionallyOverridingVersion = true;
  });
  anti-anti-cheat-patch = callPackage ./anti-anti-cheat-patch {
    qemu = fixed-qemu;
    edk2 = fixed-edk2;
  };

  aacPkgs =
    import ./aac-edk2-qemu {
      inherit
        OVMF
        anti-anti-cheat-patch
        ;
      qemu = fixed-qemu;
      edk2 = fixed-edk2;
    }
    // {
      inherit anti-anti-cheat-patch;
    };
  blenderPkgs = import ./blender-bin {
    inherit lib;
    inherit (pkgs)
      fetchurl
      nix-update-script
      makeWrapper
      stdenv
      wayland
      libdecor
      libx11
      libxi
      libxxf86vm
      libxfixes
      libxrender
      libxkbcommon
      libGLU
      libglvnd
      numactl
      SDL2
      libdrm
      ocl-icd
      openal
      alsa-lib
      pulseaudio
      libsm
      libice
      zlib
      vulkan-loader
      ;
  };

  callPkgs =
    name:
    let
      path = ./${name};
    in
    callPackage path { };
in
rec {
  override = (withContents apps callPkgs) // aacPkgs // blenderPkgs;
  packages = nixpkgs: mapAttrs (n: v: nixpkgs.${n}) override;
}
