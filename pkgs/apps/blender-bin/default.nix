{
  lib,
  fetchurl,
  nix-update-script,
  makeWrapper,
  stdenv,
  wayland,
  libdecor,
  libx11,
  libxi,
  libxxf86vm,
  libxfixes,
  libxrender,
  libxkbcommon,
  libGLU,
  libglvnd,
  numactl,
  SDL2,
  libdrm,
  ocl-icd,
  openal,
  alsa-lib,
  pulseaudio,
  libsm,
  libice,
  zlib,
  vulkan-loader,
}:
let
  inherit (lib.versions) majorMinor;
  blender-bin =
    let
      version = "5.0.1";
    in
    {
      pname = "blender-bin";
      inherit version;
      src = fetchurl {
        url = "https://ftp.nluug.nl/pub/graphics/blender/release/Blender${majorMinor version}/blender-${version}-linux-x64.tar.xz";
        sha256 = "sha256-fyR1mQYTyNTHrFaXgD/PQNCVQcH9jCOTb0sHoWmpIMc=";
      };
      passthru.updateScript = {
        command = [
          ./update.sh
          "blender-bin"
          "blender-bin"
        ];
      };
    };
  blender-bin_4_5 =
    let
      version = "4.5";
    in
    {
      pname = "blender-bin_4_5";
      inherit version;
      src = fetchurl {
        url = "https://ftp.nluug.nl/pub/graphics/blender/release/Blender4.5/blender-${version}-linux-x64.tar.xz";
        sha256 = "sha256-jMOZfKIUikMYfKYl8VC0G9PvfCmRmIclo0tGy/JbqC8=";
      };
      passthru.updateScript = nix-update-script {
        extraArgs = [
          "--flake"
          "--version-regex"
          "v(4.5.*)"
          "--url"
          "https://github.com/blender/blender"
        ];
      };
    };
  blender-bin_lts =
    let
      version = "4.5";
    in
    {
      pname = "blender-bin_lts";
      inherit version;
      src = fetchurl {
        url = "https://ftp.nluug.nl/pub/graphics/blender/release/Blender${majorMinor version}/blender-${version}-linux-x64.tar.xz";
        sha256 = "sha256-jMOZfKIUikMYfKYl8VC0G9PvfCmRmIclo0tGy/JbqC8=";
      };
      passthru.updateScript = {
        command = [
          ./update.sh
          "blender-bin_lts"
          "blender-lts-bin"
        ];
      };
    };
in
{
  blender-bin = import ./package.nix {
    inherit (blender-bin)
      pname
      version
      src
      passthru
      ;
    inherit
      lib
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
  blender-bin_4_5 = import ./package.nix {
    inherit (blender-bin_4_5)
      pname
      version
      src
      passthru
      ;
    inherit
      lib
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
  blender-bin_lts = import ./package.nix {
    inherit (blender-bin_lts)
      pname
      version
      src
      passthru
      ;
    inherit
      lib
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
}
