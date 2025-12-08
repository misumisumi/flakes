{
  stdenvNoCC,
  lib,
  name,
  pkgSources,
}:

stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;

  installPhase = ''
    mkdir -p $out/share/skk
    cp ./SKK-JISYO.emoji.utf8 $out/share/skk
  '';

  meta = with lib; {
    inherit version;
    description = "Emoji dictionary for SKK";
    homepage = "https://github.com/uasi/skk-emoji-jisyo";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
