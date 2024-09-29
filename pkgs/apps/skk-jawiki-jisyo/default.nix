{
  stdenvNoCC,
  lib,
  pkgSources,
}:
stdenvNoCC.mkDerivation rec {
  inherit (pkgSources.jawiki-kana-kanji-dict) pname src;
  version = pkgSources.jawiki-kana-kanji-dict.date;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/SKK-JISYO.jawiki
  '';

  meta = with lib; {
    inherit version;
    description = "SKK dictionary from Wikipedia(Japanese edition)";
    homepage = "https://github.com/tokuhirom/jawiki-kana-kanji-dict";
    license = licenses.mit;
  };
}
