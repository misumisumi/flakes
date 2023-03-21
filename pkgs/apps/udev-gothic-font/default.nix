{ stdenvNoCC, lib, name, pkgSources, unzip, withNerd ? false }:
let
  fName = if withNerd then "udev-gothic-nf" else "udev-gothic";
in
stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."${fName}") pname version src;
  nativeBuildInputs = [
    unzip
  ];
  sourceRoot = ".";
  unpackCmd = "unzip -o $curSrc";

  installPhase = ''
    runHook preInstall

    find -name \*.ttf -exec mkdir -p $out/share/fonts/truetype/UDEVGothic \; -exec mv {} $out/share/fonts/truetype/UDEVGothic \;

    runHook postInstall
  '';

  meta = with lib; {
    inherit version;
    description = "A composite font family of JetBrains Mono and BIZ UD Gothic";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = licenses.ofl;
  };
}
