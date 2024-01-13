{ stdenv
, lib
, name
, pkgSources
, fetchpatch
, makeDesktopItem
, makeWrapper
, alsa-plugins
, imagemagick
, snack
, tcl
, tk
, tkdnd
}:

stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;
  patches = [
    ./fix-drag-and-drop.patch
    (fetchpatch {
      name = "fix-wavebar.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-wavebar.patch?h=wavesurfer";
      sha256 = "sha256-qEcNpXuFYW9DUimSz2UQlpowcc5M5Ueq2F6nMlpKyMM=";
    })
    (fetchpatch {
      name = "fix-defaultconfig-search.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-defaultconfig-search.patch?h=wavesurfer";
      sha256 = "sha256-CCYzJMCvP4Kz84aAaLJo3Yc6Izi7iEdWITeBJxvBHLI=";
    })
    (fetchpatch {
      name = "fix-tkcon.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-tkcon.patch?h=wavesurfer";
      sha256 = "sha256-0VMjzH2Wpu00owSE5jRYmL/3DIGA8K58nvHv/epzrOU=";
    })
    (fetchpatch {
      name = "prefs.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/prefs.patch?h=wavesurfer";
      sha256 = "sha256-g6lS49EPJNB42ylawHFmAbydpUqv/2l91TnzWCNyGYU=";
    })
    (fetchpatch {
      name = "snack-callbacks.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/snack-callbacks.patch?h=wavesurfer";
      sha256 = "sha256-9HYUarE7U1wWpI5aguO5k3feup3O8MQL/RVmC+Z0sbg=";
    })
  ];
  patchPhase = ''
    for i in $patches ; do
      patch -p0 < $i
    done
  '';

  buildInputs = [
    imagemagick
    makeWrapper
    snack
    tcl
    tk
    tkdnd
  ];

  desktopItems = [
    (makeDesktopItem {
      inherit name;
      exec = name;
      icon = "wavesurfer";
      comment = "Open source tool for sound visualization and manipulation";
      desktopName = "WaveSurfer";
      categories = [ "Application" "AudioVideo" "Audio" "AudioVideoEditing" ];
      mimeTypes = [ "audio/wav" "audio/x-wav" "audio/mp3" "audio/x-mp3" "audio/mpeg" "audio/aiff" "audio/x-aiff" "audio/basic" ];
    })
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/{lib,doc}/wavesurfer
    mkdir -p $out/share/licenses/wavesurfer
    mkdir -p $out/share/icons/hicolor/48x48/apps
    mkdir -p $out/share/applications/

    cp -r demos msgs src tools $out/lib/wavesurfer/
    convert icons/icon48.xpm icons/wavesurfer.png
    cp icons/wavesurfer.png $out/share/icons/hicolor/48x48/apps/
    chmod a+x $out/lib/wavesurfer/src/app-wavesurfer/wavesurfer.tcl
    cp doc/* $out/doc/wavesurfer/
    cp $desktopItems/share/applications/* $out/share/applications/

    install LICENSE.txt $out/share/licenses/wavesurfer/LICENSE.txt
  '';

  postFixup = ''
    makeWrapper $out/lib/wavesurfer/src/app-wavesurfer/wavesurfer.tcl $out/bin/wavesurfer \
      --prefix PATH : ${lib.makeBinPath [ tk tcl ]} \
      --set TCLLIBPATH  "${snack}/lib ${tkdnd}/lib" \
      --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib
  '';

  meta = with lib; {
    inherit version;
    description = "Open source tool for sound visualization and manipulation";
    homepage = "https://sourceforge.net/projects/wavesurfer/";
    license = licenses.bsd1;
  };
}
