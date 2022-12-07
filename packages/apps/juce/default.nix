{ stdenv,
  lib,
  fetchpatch,
  name,
  pkgSources,
  alsa-lib,
  cl-freetype2,
  cl-webkit2gtk,
  cmake,
  doxygen,
  graphviz,
  gtk3,
  jack1,
  ladspa,
  python3,
}:

stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;
  buildInputs = [ alsa-lib cl-freetype2 cl-webkit2gtk cmake doxygen graphviz gtk3 jack1 ladspa python3 ];
  configureFlags = [
    "CPPFLAGS+= -DJUCER_ENABLE_GPL_MODE=1"
  ];
  outputs = [ "out" "doc" ];

  buildPhase = ''
    cmake -DCMAKE_INSTALL_PREFIX=$out \
          -DCMAKE_BUILD_TYPE=None \
          -DJUCE_BUILD_EXTRAS=ON \
          -DJUCE_TOOL_INSTALL_DIR=$out/bin \
          -Wno-dev \
          -B build \
          -S $out
    make VERBOSE=1 -C build
    make -C $doc
  '';

  installPhase = ''
    make DESTDIR=$out VERBOSE=1 -C build install
    # projucer has no install target
    install -vDm 755 build/extras/Projucer/Projucer_artefacts/None/Projucer -t "$out/bin"
    # install custom vst2 handling from juce < 5.4.1
    install -vDm 644 juce_VSTInterface.h -t "$out/share/juce/modules/juce_audio_processors/format_types/"
    # xdg desktop integration
    # install -vDm 644 *.desktop -t "$out/share/applications/"
    install -vDm 644 $_name-$pkgver/examples/Assets/juce_icon.png "$pkgdir/usr/share/icons/hicolor/512x512/apps/Projucer.png"
    # docs
    install -vDm 644 $_name-$pkgver/{{BREAKING-CHANGES,ChangeList}.txt,README.md} -t "$pkgdir/usr/share/doc/$pkgname/"
    # license
    install -vDm 644 $_name-$pkgver/LICENSE.md -t "$pkgdir/usr/share/licenses/$pkgname/"
  ''; 

  meta = with lib; {
    inherit version;
    description = "Cross-platform C++ framework";
    homepage = "https://juce.com/";
    license = licenses.unfree;
  };
}
