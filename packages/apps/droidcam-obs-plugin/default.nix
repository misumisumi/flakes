
{ stdenv, lib, fetchpatch, name, pkgSources, libimobiledevice, libjpeg, libusbmuxd, obs-studio }:

stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;
  buildInputs = [ libimobiledevice libjpeg libusbmuxd obs-studio ];
  patches = [
    ./fix-makefile.patch
  ];

  patchPhase = ''
    for i in $patches ; do
      patch -p1 < $i
    done
  '';

  buildPhase = ''
    mkdir -p build
    make ALLOW_STATIC=no -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir -p $out/lib/obs-plugins
    cp ./build/droidcam-obs.so $out/lib/obs-plugins
    mkdir -p $out/share/obs/obs-plugins/droidcam-obs
    cp -r ./data/locale $out/share/obs/obs-plugins/droidcam-obs/
  '';

  meta = with lib; {
    inherit version;
    description = "plugin for droidcam obs";
    homepage = "https://github.com/dev47apps/droidcam-obs-plugin";
    license = licenses.gpl2;
  };
}
