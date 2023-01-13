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
  # , useJinmei ? true
  # , useFullName ? false
  # , useGeo ? false
  # , usePropernoun ? false
  # , useStation ? false
  # , useLaw ? false
  # , useOkinawa ? false
  # , useChinaTaiwan ? false
, useAssoc ? false
, useEdict ? false
  # , useZipcode ? false
  # , useOfficeZipcode ? false
}:
let
  dicts = { "Minimal" = "SKK-JISYO.S"; "Middle" = "SKK-JISYO.M"; "Large" = "SKK-JISYO.L"; "Combined" = "SKK-JISYO.combined"; };
  addDict = dict: "type=file,file=" + "${skk-dicts}/share/" + "${dict},mode=readonly";
  optionalString = lib.strings.optionalString;
in
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
      --replace /usr/share/skk/SKK-JISYO.L ${skk-dicts}/share/${dicts.${useDict}}
  ''
  # + optionalString (useJinmei) "\necho '${addDict "SKK-JISYO.jinmei"}' >> src/dictonary_list.in"
  # + optionalString (useFullName) "\necho '${addDict "SKK-JISYO.fullname"}' >> src/dictonary_list.in"
  # + optionalString (useGeo) "\necho '${addDict "SKK-JISYO.geo"}' >> src/dictonary_list.in"
  # + optionalString (usePropernoun) "\necho '${addDict "SKK-JISYO.propernoun"}' >> src/dictonary_list.in"
  # + optionalString (useStation) "\necho '${addDict "SKK-JISYO.station"}' >> src/dictonary_list.in"
  # + optionalString (useLaw) "\necho '${addDict "SKK-JISYO.law"}' >> src/dictonary_list.in"
  # + optionalString (useOkinawa) "\necho '${addDict "SKK-JISYO.okinawa"}' >> src/dictonary_list.in"
  # + optionalString (useChinaTaiwan) "\necho '${addDict "SKK-JISYO.china_taiwan"}' >> src/dictonary_list.in"
  + optionalString (useAssoc) "\necho '${addDict "SKK-JISYO.assoc"}' >> src/dictonary_list.in"
  + optionalString (useEdict) "\necho '${addDict "SKK-JISYO.edict"}' >> src/dictonary_list.in";
  # + optionalString (useZipcode) "\necho '${addDict "SKK-JISYO.zipcode"}' >> src/dictonary_list.in"
  # + optionalString (useOfficeZipcode) "\necho '${addDict "SKK-JISYO.office.zipcode"}' >> src/dictonary_list.in";

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
