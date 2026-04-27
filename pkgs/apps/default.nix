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
    qemu
    OVMF
    buildPackages
    anti-anti-cheat-patch
    ;

  inherit (import ../utils.nix { inherit lib python3 callPackage; }) withContents;

  ignorePkgs = [
    "aac-edk2-qemu"
    "blender-bin"
  ];

  apps = attrNames (
    filterAttrs (n: v: (all (p: n != p) ignorePkgs) && (v == "directory")) (readDir ./.)
  );

  aacPkgs = import ./aac-edk2-qemu {
    inherit
      OVMF
      anti-anti-cheat-patch
      buildPackages
      qemu
      ;
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
