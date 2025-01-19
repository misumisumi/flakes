{
  stdenvNoCC,
  lib,
  pkgSources,
  unzip,
}:
let
  knownFonts = [
    "Moralerspace"
    "MoralerspaceHW"
    "MoralerspaceHWJPDOC"
    "MoralerspaceJPDOC"
  ];
  srcs = map (fName: pkgSources."${fName}".src) knownFonts;
in
stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."Moralerspace") version;
  inherit srcs;
  pname = "moralerspace-fonts";

  nativeBuildInputs = [
    unzip
  ];
  sourceRoot = ".";
  unpackCmd = "unzip -o $curSrc";
  installPhase = ''
    runHook preInstall

    find -name \*.ttf -exec mkdir -p $out/share/fonts/truetype/molalerspace \; -exec mv {} $out/share/fonts/truetype/molalerspace \;

    runHook postInstall
  '';

  meta = {
    inherit version;
    description = "A composite font family of monaspace and IBM Plex Sansjp";
    homepage = "https://github.com/yuru7/moralerspace";
    license = lib.licenses.ofl;
  };
}
