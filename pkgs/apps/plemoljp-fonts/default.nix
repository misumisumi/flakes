{ stdenvNoCC, lib, name, pkgSources, unzip, fonts ? [ ] }:
let
  knownFonts = [ "plemoljp-hs" "plemoljp-nfj" "plemoljp-nf" "plemoljp" ];
  selectedFonts =
    if (fonts == [ ]) then
      knownFonts
    else
      let unknown = lib.subtractLists knownFonts fonts; in
      if (unknown != [ ]) then
        throw "Unknown font(s): ${lib.concatStringsSep " " unknown}"
      else
        fonts
  ;
  srcs = map (fName: pkgSources."${fName}".src) selectedFonts;
in
stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."plemoljp") version;
  inherit srcs;
  pname = "plemoljp-fonts";

  nativeBuildInputs = [
    unzip
  ];
  sourceRoot = ".";
  unpackCmd = "unzip -o $curSrc";
  buildPhase = ''
    echo "selected fonts are ${toString selectedFonts}"
    ls *.otf *.ttf
  '';
  installPhase = ''
    runHook preInstall

    find -name \*.ttf -exec mkdir -p $out/share/fonts/truetype/PlemolJP \; -exec mv {} $out/share/fonts/truetype/PlemolJP \;

    runHook postInstall
  '';

  meta = with lib; {
    inherit version;
    description = "A composite font family of IBM Plex Mono and IBM Plex Sansjp (optional nerd-fonts)";
    homepage = "https://github.com/yuru7/PlemolJP";
    license = licenses.ofl;
  };
}
