{
  lib,
  fetchurl,
  stdenvNoCC,
}:
let
  version = "2026.08.21.141555";
in
stdenvNoCC.mkDerivation {
  pname = "skk-jawiki-jisyo";
  inherit version;
  src = fetchurl {
    url = "https://github.com/tokuhirom/jawiki-kana-kanji-dict/releases/download/v${version}/SKK-JISYO.jawiki";
    sha256 = "sha256-el5JHJ5L6U3CEfGihIO5AVIBN+PAOC86KyzOukywqGU=";
  };
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/skk
    cp $src $out/share/skk/SKK-JISYO.jawiki
  '';

  meta = with lib; {
    description = "SKK dictionary from Wikipedia(Japanese edition)";
    homepage = "https://github.com/tokuhirom/jawiki-kana-kanji-dict";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
