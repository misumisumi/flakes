{ stdenv, lib, name, pkgSources, writeShellScript, makeDesktopItem, makeWrapper, tk, tcl, snack }:

stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;

  buildInputs = [ makeWrapper ];
  nativeBuildInputs = [ tk tcl snack ];

  desktopItems = [ 
    (makeDesktopItem {
      inherit name;
      exec = name;
      icon = "wavesurfer_48";
      comment = "Open source tool for sound visualization and manipulation";
      desktopName = "WaveSurfer";
      categories = [ "Application" "AudioVideo" "Audio" "AudioVideoEditing" ];
    })
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/{lib,doc}/wavesurfer
    mkdir -p $out/share/licenses/wavesurfer
    mkdir -p $out/share/icons/hicolor/48x48/apps
    mkdir -p $out/share/applications/

    cp -r demos msgs src tools $out/lib/wavesurfer/
    cp icons/icon48.xpm $out/share/icons/hicolor/48x48/apps/wavesurfer.xpm
    chmod a+x $out/lib/wavesurfer/src/app-wavesurfer/wavesurfer.tcl
    cp doc/* $out/doc/wavesurfer/
    cp $desktopItems/share/applications/* $out/share/applications/

    cat <<EOF > $out/bin/wavesurfer
    exec $out/lib/wavesurfer/src/app-wavesurfer/wavesurfer.tcl "''$@"
    EOF
    chmod a+x $out/bin/wavesurfer
    install LICENSE.txt $out/share/licenses/wavesurfer/LICENSE.txt
  '';

  postFixup = ''
    wrapProgram $out/bin/wavesurfer \
      --prefix PATH : ${lib.makeBinPath [ tk tcl ]} \
      --prefix TCLLIBPATH : ${lib.makeLibraryPath [ snack ]}
  '';

  meta = with lib; {
    inherit version;
    description = "Open source tool for sound visualization and manipulation";
    homepage = "https://sourceforge.net/projects/wavesurfer/";
    license = licenses.bsd1;
  };
}
