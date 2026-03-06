{
  pkgSource,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  inherit (pkgSource) pname src;
  version = lib.removePrefix "v" pkgSource.version;

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
