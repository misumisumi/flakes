{ stdenvNoCC, lib, fetchpatch, name, pkgSources }:

stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;

  installPhase = ''
    mkdir -p $out/share
    cp ./SKK-JISYO.emoji.utf8 $out/share
  '';

  meta = with lib; {
    inherit version;
    description = "Emoji dictionary for SKK";
    homepage = "https://github.com/uasi/skk-emoji-jisyo";
    license = licenses.mit;
  };
}
