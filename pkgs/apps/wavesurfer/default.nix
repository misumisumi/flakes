{
  lib,
  fetchurl,
  stdenv,
  makeDesktopItem,
  makeWrapper,
  writeScript,
  alsa-plugins,
  curl,
  imagemagick,
  snack,
  tcl,
  tk,
  tkdnd,
}:
let
  pname = "wavesurfer";
  version = "1.8.8p5";
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchurl {
    url = "http://downloads.sourceforge.net/${pname}/${pname}-${version}-src.tgz";
    sha256 = "sha256-rlYGEUfdEXD3SF3JwZ23pF3RVwUKw5RmYsf8ec/7YRo=";
  };
  patches = [
    ./fix-defaultconfig-search.patch
    ./fix-drag-and-drop.patch
    ./fix-tkcon.patch
    ./fix-wavebar.patch
    ./prefs.patch
    ./snack-callbacks.patch
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
      name = "wavesurfer";
      exec = "wavesurfer";
      icon = "wavesurfer";
      comment = "Open source tool for sound visualization and manipulation";
      desktopName = "WaveSurfer";
      categories = [
        "Application"
        "AudioVideo"
        "Audio"
        "AudioVideoEditing"
      ];
      mimeTypes = [
        "audio/wav"
        "audio/x-wav"
        "audio/mp3"
        "audio/x-mp3"
        "audio/mpeg"
        "audio/aiff"
        "audio/x-aiff"
        "audio/basic"
      ];
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
      --prefix PATH : ${
        lib.makeBinPath [
          tk
          tcl
        ]
      } \
      --set TCLLIBPATH  "${snack}/lib ${tkdnd}/lib" \
      --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib
  '';

  passthru = {
    updateScript = writeScript "snack-patch-update" ''
      #!${stdenv.shell}
      set -eu -o pipefail

      pushd pkgs/apps/wavesurfer

      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/fix-wavebar.patch?h=wavesurfer" -o fix-wavebar.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/fix-defaultconfig-search.patch?h=wavesurfer" -o fix-defaultconfig-search.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/fix-tkcon.patch?h=wavesurfer" -o fix-tkcon.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/prefs.patch?h=wavesurfer" -o prefs.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/snack-callbacks.patch?h=wavesurfer" -o snack-callbacks.patch

      popd
    '';
  };

  meta = with lib; {
    description = "Open source tool for sound visualization and manipulation";
    homepage = "https://sourceforge.net/projects/wavesurfer/";
    license = licenses.bsd1;
    platforms = [ "x86_64-linux" ];
  };
}
