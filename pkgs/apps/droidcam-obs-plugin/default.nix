{ stdenvNoCC, lib, fetchpatch, name, pkgSources, libimobiledevice, libjpeg_turbo, libusbmuxd, obs-studio, unzip }:

stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;
  buildInputs = [ libimobiledevice libjpeg_turbo libusbmuxd obs-studio ];
  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src -d /build/
  '';

  installPhase = ''
    mkdir -p $out/lib/obs-plugins
    cp ./droidcam-obs/bin/64bit/droidcam-obs.so $out/lib/obs-plugins
    mkdir -p $out/share/obs/obs-plugins/droidcam-obs
    cp -r ./droidcam-obs/data/locale $out/share/obs/obs-plugins/droidcam-obs/
  '';

  meta = with lib; {
    inherit version;
    description = "plugin for droidcam obs";
    homepage = "https://github.com/dev47apps/droidcam-obs-plugin";
    license = licenses.gpl2;
  };
}
