{ stdenv,
  lib,
  fetchpatch,
  name,
  pkgSources,
  makeDesktopItem,
  alsa-lib,
  cmake,
  curl,
  doxygen,
  flac,
  freetype,
  graphviz,
  gtk3,
  jack1,
  ladspaH,
  libjpeg_turbo,
  libogg,
  libpng,
  libvorbis,
  pkg-config,
  perlPackages,
  python3,
  webkitgtk,
  zlib,
}:
let
  # Need jpegint.h
  libjpeg_with_jpegint = libjpeg_turbo.overrideAttrs (old: {
    postInstall = ''
      install -vDm 644 $src/jpegint.h "$dev/include"
    '';
  });
in
stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;
  patches = [
    ./juce-6.1.3-cmake_link_against_system_deps.patch
    ./juce-6.1.2-devendor_libs.patch
  ];
  buildInputs = [ alsa-lib curl doxygen flac freetype graphviz gtk3 jack1 ladspaH
                  libjpeg_with_jpegint libogg libpng libvorbis webkitgtk zlib ] ++
                  (with perlPackages; [ ArchiveZip ]);
  nativeBuildInputs = [ cmake python3 pkg-config ];
  postPatch = ''
    rm -rvf modules/juce_audio_formats/codecs/flac/ \
        modules/juce_audio_formats/codecs/oggvorbis/ \
        modules/juce_audio_plugin_client/AU/ \
        modules/juce_graphics/image_formats/jpglib/ \
        modules/juce_graphics/image_formats/pnglib/ \
        modules/juce_core/zip/zlib/
  '';
  configureFlags = [
    "CPPFLAGS+= -DJUCER_ENABLE_GPL_MODE=1"
  ];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=None"
    "-DJUCE_BUILD_EXTRAS=ON"
    "-Wno-dev"
  ];

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
