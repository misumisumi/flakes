{ stdenvNoCC
, lib
, pkgSources
, unzip
, fonts ? [ ]
,
}:
let
  knownFonts = [ "moralerspace-hw-jpdoc" "moralerspace-jpdoc" "moralerspace-hw" "moralerspace" ];
  selectedFonts =
    if (fonts == [ ])
    then knownFonts
    else
      let
        unknown = lib.subtractLists knownFonts fonts;
      in
      if (unknown != [ ])
      then throw "Unknown font(s): ${lib.concatStringsSep " " unknown}"
      else fonts;
  srcs = map (fName: pkgSources."${fName}".src) selectedFonts;
in
stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."moralerspace") version;
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
