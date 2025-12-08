{
  stdenvNoCC,
  lib,
  fcitx5-mozc,
  yaskkserv2,
  python3,
}:
let
  script = ./to-jisyo.py;
in
stdenvNoCC.mkDerivation rec {
  pname = "skk-kaomoji-jisyo";
  inherit (fcitx5-mozc) src version;
  nativeBuildInputs = [
    python3
    yaskkserv2
  ];

  installPhase = ''
    mkdir -p $out/share/skk
    python ${script} --input_file src/data/emoticon/emoticon.tsv --output_file SKK-JISYO.kaomoji.utf8
    cp SKK-JISYO.kaomoji.utf8 $out/share/skk/SKK-JISYO.kaomoji.utf8
  '';

  meta = with lib; {
    inherit version;
    description = "Kaomoji SKK dictionary from mozc";
    homepage = "https://github.com/fcitx/mozc";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
