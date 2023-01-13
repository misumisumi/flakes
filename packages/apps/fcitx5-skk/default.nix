{ stdenv, lib, name, pkgSources, cmake, extra-cmake-modules, ninja, pkg-config, fcitx5, qt5, libsForQt5, libskk, skk-dicts }:

stdenv.mkDerivation
{
  inherit (pkgSources."${name}") pname version src;

  nativeBuildInputs = [ cmake ninja extra-cmake-modules pkg-config ];
  buildInputs = [ fcitx5 libsForQt5.fcitx5-qt qt5.qtbase libskk skk-dicts ];
  dontWrapQtApps = true;

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_INSTALL_PREFIX=/"
    "-DCMAKE_INSTALL_LIBDIR=/lib"
  ];
  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace /usr/share/skk/SKK-JISYO.L ${skk-dicts}/share/SKK-JISYO.L
  '';

  buildPhase = ''
    cmake $cmakeFlags .
    ninja
  '';

  installPhase = ''
    mkdir $out
    DESTDIR=build ninja install
    cp -r build/usr/share $out/
    cp -r build/lib $out/
  '';

  meta = with lib; {
    description = "A SKK style input method engine for fcitx5";
    longDescription = ''
      Fcitx5-skk is an input method engine for fcitx5. It is based on libskk and thus
      provides basic features of SKK Japanese input method such as kana-to-kanji conversion,
      new word registration, completion, numeric conversion, abbrev mode, kuten input,
      hankaku-katakana input, and re-conversion.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };

}
