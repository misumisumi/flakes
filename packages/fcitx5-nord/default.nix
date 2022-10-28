{ stdenvNoCC, lib, name, pkgSources }:

stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;

  installPhase = ''
    mkdir -p $out/share/fcitx5/themes
    cp -r Nord-Dark/ Nord-Light/ $out/share/fcitx5/themes/
  '';

  meta = with lib; {
    inherit version;
    description = "Fcitx5 theme to match KDE's Breeze style";
    homepage = "https://github.com/tonyfettes/fcitx5-nord";
    license = licenses.mit;
  };
}
