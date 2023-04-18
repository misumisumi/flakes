{
  lib,
  name,
  pkgSources,
  stdenv,
  dpkg,
}:
stdenv.mkDerivation {
  inherit (pkgSources."${name}") src version pname;

  nativeBuildInputs = [dpkg];

  unpackPhase = ''
    runHook preUnpack
    mkdir $out
    dpkg-deb -x $src $out
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
