{
  lib,
  stdenvNoCC,
  skk-emoji-jisyo,
  skk-emoticons-jisyo,
  skk-jawiki-jisyo,
  skk-kaomoji-jisyo,
  skkDictionaries,
  yaskkserv2,
  withEmoji ? true,
  withKaomoji ? true,
  withEmoticons ? true,
}:
let
  inherit (lib.strings) optionalString;
  isUtf8 = withEmoji || withKaomoji || withEmoticons;
in
stdenvNoCC.mkDerivation {
  pname = "yaskkserv2-dict";
  inherit (skk-jawiki-jisyo) version;
  dontUnpack = true;

  buildPhase = ''
    ${yaskkserv2}/bin/yaskkserv2_make_dictionary \
      --dictionary-filename ./dictionary.yaskkserv2 \
      ${optionalString isUtf8 " --utf8"} \
      ${skkDictionaries.l}/share/skk/SKK-JISYO.L \
      ${skk-jawiki-jisyo}/share/skk/SKK-JISYO.jawiki \
      ${optionalString withEmoji "${skk-emoji-jisyo}/share/skk/SKK-JISYO.emoji.utf8"} \
      ${optionalString withKaomoji "${skk-kaomoji-jisyo}/share/skk/SKK-JISYO.kaomoji.utf8"} \
      ${optionalString withEmoticons "${skk-emoticons-jisyo}/share/skk/SKK-JISYO.emoticons.utf8"} \

    ${yaskkserv2}/bin/yaskkserv2_make_dictionary \
      --dictionary-filename ./dictionary.yaskkserv2 \
      ${optionalString isUtf8 " --utf8"} \
      --output-jisyo-filename ./SKK-JISYO.yaskkserv2.utf8
  '';

  installPhase = ''
    mkdir -p $out/share
    cp dictionary.yaskkserv2 $out/share/
    cp SKK-JISYO.yaskkserv2.utf8 $out/share/
  '';

  meta = {
    description = "Dictionary for yaskkserv2 include Emoji and jawiki-kana-kanji-dict";
    platforms = lib.platforms.all;
  };
}
