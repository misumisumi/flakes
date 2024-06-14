{ stdenvNoCC
, lib
, pkgSources
, unzip
, fonts ? [ ]
,
}:
let
  knownFonts = [ "moralerspace-hw-nf" "moralerspace-nf" ];
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
  inherit (pkgSources."moralerspace-nf") version;
  inherit srcs;
  pname = "moralerspace-nerd-fonts";

  nativeBuildInputs = [
    unzip
  ];
  sourceRoot = ".";
  unpackCmd = "unzip -o $curSrc";
  installPhase = ''
    runHook preInstall

    find -name \*.ttf -exec mkdir -p $out/share/fonts/truetype/molalerspace-nerd \; -exec mv {} $out/share/fonts/truetype/molalerspace-nerd \;

    runHook postInstall
  '';

  meta = {
    inherit version;
    description = "A composite font family of monaspace and IBM Plex Sansjp include nerd-fonts";
    homepage = "https://github.com/yuru7/moralerspace";
    license = lib.licenses.ofl;
  };
}
