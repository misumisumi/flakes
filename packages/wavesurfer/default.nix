{ stdenv, lib, name, pkgSources, writeShellScript, makeDesktopItem, tk, tcl, snack }:
let
  launcher = writeShellScript "wavesurfer" ''
    #! /usr/bin/env bash
    exec $out/src/app-wavesurfer/wavesurfer.tcl "''$@"
  '';

  desktopApp = makeDesktopItem {
    inherit name;
    exec = name;
    icon = "wavesurfer_48";
    comment = "Open source tool for sound visualization and manipulation";
    desktopName = "WaveSurfer";
    categories = [ "Application" "AudioVideo" "Audio" "AudioVideoEditing" ];
  };
in
stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;

  nativeBuildInputs = [ tk tcl snack ];

  outputs = [ "out" "bin" "lib" "doc" ];

  
  installPhase = ''
    mkdir -p {$lib,$doc}/wavesurfer
    mkdir -p $out/share/licenses/wavesurfer
    mkdir -p $out/share/icons/hicolor/48x48/apps
    mkdir -p $out/share/applications/

    cp -r demos msgs src tools $lib/wavesurfer/
    cp -r icons/icon48.xpm $out/share/icons/hicolor/48x48/apps
    chmod a+x $lib/wavesurfer/src/app-wavesurfer/wavesurfer.tcl
    cp doc/* $doc/wavesurfer/

    install -Dm755 ${launcher} $bin/wavesurfer
    install LICENSE.txt $out/share/licenses/wavesurfer/LICENSE.txt
  '';

  meta = with lib; {
    inherit version;
    description = "Open source tool for sound visualization and manipulation";
    homepage = "https://sourceforge.net/projects/wavesurfer/";
    license = licenses.bsd1;
  };
}
