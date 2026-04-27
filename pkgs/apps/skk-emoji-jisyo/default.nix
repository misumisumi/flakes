{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
let
  pname = "skk-emoji-jisyo";
  version = "0.0.9";
in
stdenvNoCC.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "uasi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H73wfvFhff55vFvNOunkma3C28BnXGuLzMrSvTLTgXU=";
  };

  installPhase = ''
    mkdir -p $out/share/skk
    cp ./SKK-JISYO.emoji.utf8 $out/share/skk
  '';

  meta = with lib; {
    description = "Emoji dictionary for SKK";
    homepage = "https://github.com/uasi/skk-emoji-jisyo";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
