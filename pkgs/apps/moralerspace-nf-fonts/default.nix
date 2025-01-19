{
  stdenvNoCC,
  lib,
  pkgSources,
  unzip,
  fonts ? [ ],
}:
let
  knownFonts = [
    "MoralerspaceNF"
    "MoralerspaceHWNF"
  ];
  selectedFonts =
    if (fonts == [ ]) then
      knownFonts
    else
      let
        unknown = lib.subtractLists knownFonts fonts;
      in
      if (unknown != [ ]) then throw "Unknown font(s): ${lib.concatStringsSep " " unknown}" else fonts;
  srcs = map (fName: pkgSources."${fName}".src) selectedFonts;
in
stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."MoralerspaceNF") version;
  inherit srcs;
  pname = "moralerspace-nf-fonts";

  nativeBuildInputs = [
    unzip
  ];
  sourceRoot = ".";
  unpackCmd = "unzip -o $curSrc";
  installPhase = ''
    runHook preInstall

    find -name \*.ttf -exec mkdir -p $out/share/fonts/truetype/molalerspace-nf \; -exec mv {} $out/share/fonts/truetype/molalerspace-nf \;

    runHook postInstall
  '';

  meta = {
    inherit version;
    description = "A composite font family of monaspace and IBM Plex Sansjp include nerd-fonts";
    homepage = "https://github.com/yuru7/moralerspace";
    license = lib.licenses.ofl;
  };
}
