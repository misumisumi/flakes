{
  lib,
  fetchurl,
  stdenvNoCC,
}:
let
  version = "2026.07.21.141341";
in
stdenvNoCC.mkDerivation {
  pname = "skk-jawiki-jisyo";
  inherit version;
  src = fetchurl {
    url = "https://github.com/tokuhirom/jawiki-kana-kanji-dict/releases/download/v${version}/SKK-JISYO.jawiki";
    sha256 = "sha256-UcmvRD7cZh3SjXgZ5F4Gj4lQD/LiX/6p5ZyG+3mI48Q=";
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
