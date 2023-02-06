{ stdenv
, lib
, name
, pkgSources
, cmake
, extra-cmake-modules
, ninja
, pkg-config
, fcitx5
, qt5
, libsForQt5
, libskk
, skk-dicts
, useDict ? "Combined"
, useAssoc ? false
, useEdict ? false
, useEmoji ? false
, skk-emoji-jisyo ? null
}:
let
  dicts = { "Minimal" = "SKK-JISYO.S"; "Middle" = "SKK-JISYO.M"; "Large" = "SKK-JISYO.L"; "Combined" = "SKK-JISYO.combined"; };
  addDict = dict: "type=file,file=" + "${skk-dicts}/share/" + "${dict},mode=readonly";
in
with lib; stdenv.mkDerivation
{
  inherit (pkgSources."${name}") pname version src;

  nativeBuildInputs = [ cmake ninja extra-cmake-modules pkg-config ];
  buildInputs = [ fcitx5 libsForQt5.fcitx5-qt qt5.qtbase libskk skk-dicts ]
    ++ optional (useEmoji) skk-emoji-jisyo;
  dontWrapQtApps = true;

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_INSTALL_PREFIX=/"
    "-DCMAKE_INSTALL_LIBDIR=/lib"
  ];

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace /usr/share/skk/SKK-JISYO.L ${skk-dicts}/share/${dicts.${useDict}}
  ''
  + optionalString (useAssoc) "\necho '${addDict "SKK-JISYO.assoc"}' >> src/dictonary_list.in"
  + optionalString (useEdict) "\necho '${addDict "SKK-JISYO.edict"}' >> src/dictonary_list.in"
  + optionalString (useEmoji) "\necho 'type=file,file=${skk-emoji-jisyo}/share/SKK-JISYO.emoji.utf8' >> src/dictonary_list.in";

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
