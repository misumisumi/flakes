{ stdenvNoCC, lib, name, pkgSources, withNerd ? false }:
let
  fName = if withNerd then "udev-gothic-nf" else "udev-gothic";
in
stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."${fName}") pname version src;

  installPhase = ''
    runHook preInstall

    find -name \*.ttf -exec mkdir -p $out/share/fonts/truetype/udevgothic \; -exec mv {} $out/share/fonts/truetype/udevgothic \;

    runHook postInstall
  '';

  meta = with lib; {
    inherit version;
    description = "A composite font family of JetBrains Mono and BIZ UD Gothic";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = licenses.ofl;
  };
}
