{
  pkgSource,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  inherit (pkgSource) pname src version;
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
