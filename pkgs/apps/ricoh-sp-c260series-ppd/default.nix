{
  lib,
  name,
  pkgSources,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
}: let
  arches = ["x86_64" "i686" "armv7l"];

  name = "cups-brother-hll5100dn";
in
  stdenv.mkDerivation {
    pname = name;
    inherit (pkgSources."${name}-lpr") version;

    nativeBuildInputs = [dpkg makeWrapper autoPatchelfHook];

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb -x ${pkgSources."${name}-lpr".src} $out
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mv $out/usr/* $out
      rm -rf $out/usr
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "http://support.ricoh.com/bbv2/html/dr_ut_d/ipsio/history/w/bb/pub_j/dr_ut_d/4101035/4101035832/V100/5205252/sp-c260series-printer-1.00-amd64/history.htm";
      description = "richo c260seriees printer driver";
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  }
