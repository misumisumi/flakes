{ stdenvNoCC, lib, name, pkgSources, yaskkserv2, skk-dicts, skk-emoji-jisyo, isUtf8 ? true }:
let
  optionalString = lib.strings.optionalString;
in
stdenvNoCC.mkDerivation {
  pname = "yaskkserv2-dict";
  inherit (pkgSources.jawiki-kana-kanji-dict) src version;
  dontUnpack = true;

  buildPhase = ''
    ${yaskkserv2}/bin/yaskkserv2_make_dictionary --dictionary-filename ./dictionary.yaskkserv2 \
      ${skk-dicts}/share/SKK-JISYO.combined ${skk-emoji-jisyo}/share/SKK-JISYO.emoji.utf8 $src \
  '' + optionalString (isUtf8) " --utf8";

  installPhase = ''
    mkdir -p $out/share
    cp dictionary.yaskkserv2 $out/share/
  '';

  meta = with lib; {
    description = "Dictionary for yaskkserv2 include Emoji and jawiki-kana-kanji-dict";
  };
}
