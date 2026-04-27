{
  pname,
  version,
  src,
  passthru,
  lib,
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
  inherit (builtins) replaceStrings;
  inherit (lib) versionAtLeast;

  libs = [
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
    stdenv.cc.cc.lib
    openal
    alsa-lib
    pulseaudio
  ]
  ++ lib.optionals (versionAtLeast version "3.5") [
    libsm
    libice
    zlib
  ]
  ++ lib.optionals (versionAtLeast version "4.5") [ vulkan-loader ];
  mainProgram =
    if pname == "blender-bin" then "blender" else (replaceStrings [ "-bin" ] [ "" ] pname);
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    ;

  buildInputs = [ makeWrapper ];

  preUnpack = ''
    mkdir -p $out/libexec
    cd $out/libexec
  '';

  installPhase = ''
    cd $out/libexec
    mv blender-* blender

    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/apps
    mv ./blender/blender.desktop $out/share/applications/${mainProgram}.desktop
    mv ./blender/blender.svg $out/share/icons/hicolor/scalable/apps/${mainProgram}.svg

    mkdir $out/bin

    makeWrapper $out/libexec/blender/blender $out/bin/${mainProgram} \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:${lib.makeLibraryPath libs}

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/libexec/blender/blender

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"  \
      $out/libexec/blender/*/python/bin/python3*
  '';
  meta = {
    inherit mainProgram;
    platforms = [
      "x86_64-linux"
    ];
  };
}
