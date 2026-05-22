{
  lib,
  fetchurl,
  stdenvNoCC,
}:
let
  version = "2026.05.21.143857";
in
stdenvNoCC.mkDerivation {
  pname = "skk-jawiki-jisyo";
  inherit version;
  src = fetchurl {
    url = "https://github.com/tokuhirom/jawiki-kana-kanji-dict/releases/download/v${version}/SKK-JISYO.jawiki";
    sha256 = "sha256-jF7rxfISTXMifKqy2wU3599ObGnOth4rO6MXHHp4iBY=";
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
