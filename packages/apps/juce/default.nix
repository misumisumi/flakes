{ stdenv,
  lib,
  fetchpatch,
  name,
  pkgSources,
  makeDesktopItem,
  makeWrapper,
  alsa-lib,
  cmake,
  curl,
  doxygen,
  flac,
  fontconfig,
  freetype,
  glib,
  gio-sharp,
  graphviz,
  gtk3,
  ladspaH,
  libGL,
  libX11,
  libXcursor,
  libXrandr,
  libXext,
  libjack2,
  libjpeg_turbo,
  libogg,
  libpng,
  libvorbis,
  pcre2,
  perlPackages,
  pkg-config,
  python3,
  util-linux,
  webkitgtk,
  zlib
}:
let
  # Need jpegint.h
  libjpeg_with_jpegint = libjpeg_turbo.overrideAttrs (old: {
    postInstall = ''
      install -vDm 644 $src/jpegint.h "$dev/include"
    '';
  });
in
stdenv.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;
  patches = [
    ./juce-6.1.3-cmake_link_against_system_deps.patch
    ./juce-6.1.2-devendor_libs.patch
    ./juce-6.1.2-cmake_install.patch
    ./juce-6.1.2-cmake_juce_utils.patch
    ./juce-6.1.2-projucer_disable_update_check.patch
  ];
  buildInputs = [ alsa-lib cmake curl doxygen flac fontconfig freetype glib gio-sharp graphviz gtk3 ladspaH libGL 
                  libX11 libXcursor libXrandr libXext libjack2 libjpeg_with_jpegint libogg libpng
                  libvorbis pcre2 pkg-config python3 util-linux webkitgtk zlib ] ++
                  (with perlPackages; [ ArchiveZip ]);
  nativeBuildInputs = [ cmake python3 pkg-config makeWrapper ];

  desktopItems = [ 
    (makeDesktopItem {
      name = "Projucer";
      exec = "Projucer";
      icon = "Projucer";
      comment = "Cross-platform project manager and C++ code editor";
      desktopName = "Projucer";
      categories = [ "Development" ];
    })
  ];
  postPatch = ''
    rm -rf modules/juce_audio_formats/codecs/flac/ \
        modules/juce_audio_formats/codecs/oggvorbis/ \
        modules/juce_audio_plugin_client/AU/ \
        modules/juce_graphics/image_formats/jpglib/ \
        modules/juce_graphics/image_formats/pnglib/ \
        modules/juce_core/zip/zlib/
    substituteInPlace extras/Projucer/Source/Settings/jucer_StoredSettings.cpp
    --replace "return (os == TargetOS::windows ? "C:\\JUCE" : "~/JUCE");" \
      "return (os == TargetOS::windows ? "C:\\JUCE" : "$out/share/doc/juce");"

    substituteInPlace extras/Projucer/Source/Settings/jucer_StoredSettings.cpp
    --replace "return (os == TargetOS::windows ? "C:\\JUCE\\modules" : "~/JUCE/modules");" \
      "return (os == TargetOS::windows ? "C:\\modules" : "$out/share/juce/modules");"

    substituteInPlace extras/Projucer/Source/Settings/jucer_StoredSettings.cpp
    --replace "return (os == TargetOS::windows ? "C:\\modules" : "~/modules");" \
      "return (os == TargetOS::windows ? "C:\\modules" : "~/.local/share/juce/modules");"
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=None"
    "-DJUCE_BUILD_EXTRAS=ON"
    "-DJUCE_TOOL_INSTALL_DIR=bin"
    "-Wno-dev"
  ];
  CPPFLAGS = "-DJUCER_ENABLE_GPL_MODE=1";

  installPhase = ''
    mkdir -p $out/share/icons/hicolor/512x512/apps/
    mkdir -p $out/share/doc/$pname
    mkdir -p $out/share/licenses/$pname

    make install
    # projucer has no install target
    install -vDm 755 /build/source/build/extras/Projucer/Projucer_artefacts/None/Projucer -t "$out/bin"

    cp $src/examples/Assets/juce_icon.png $out/share/icons/hicolor/512x512/apps/Projucer.png
    cp $src/{{BREAKING-CHANGES,ChangeList}.txt,README.md} $out/share/doc/$pname/
    cp $src/LICENSE.md $out/share/licenses/$pname/

    cp -r $desktopItems/share/applications $out/share/
  ''; 

  meta = with lib; {
    inherit version;
    description = "Cross-platform C++ framework";
    homepage = "https://juce.com/";
    license = licenses.unfree;
  };
}
