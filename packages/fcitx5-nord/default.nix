{ stdenvNoCC, lib, name, pkgSources }:

stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;

  installPhase = ''
    mkdir $out
    cp -r Nord-Dark/ Nord-Light/ $out
  '';

  meta = with lib; {
    inherit version;
    description = "Fcitx5 theme to match KDE's Breeze style";
    homepage = "https://github.com/tonyfettes/fcitx5-nord";
    license = licenses.mit;
  };
}
