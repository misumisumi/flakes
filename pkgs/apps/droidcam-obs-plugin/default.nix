{ pkgSources, name, lib, stdenv, pkg-config, obs-studio, ffmpeg, libjpeg_turbo, libimobiledevice, libusbmuxd, libplist }:

stdenv.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;
  postPatch = ''
    substituteInPlace ./linux/linux.mk \
      --replace-fail "libturbojpeg.a" "libturbojpeg.so" \
      --replace-fail "libimobiledevice.a" "libimobiledevice-1.0.so" \
      --replace-fail "\$(IMOBILEDEV_LIB)/libusbmuxd.a" "${libusbmuxd.out}/lib/libusbmuxd-2.0.so" \
      --replace-fail "\$(IMOBILEDEV_LIB)/libplist-2.0.a" "${libplist.out}/lib/libplist-2.0.so"
    cat ./linux/linux.mk
  '';
  preBuild = ''
    mkdir ./build
  '';
  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libjpeg_turbo
    libimobiledevice
    libusbmuxd
    libplist
    obs-studio
    ffmpeg
  ];

  makeFlags = [
    "ALLOW_STATIC=yes"
    "JPEG_DIR=${libjpeg_turbo.out}"
    "JPEG_LIB=${libjpeg_turbo.out}/lib"
    "IMOBILEDEV_DIR=${libimobiledevice.out}"
    "IMOBILEDEV_LIB=${libimobiledevice.out}/lib"
    "LIBOBS_INCLUDES=${obs-studio}/include/obs"
    "FFMPEG_INCLUDES=${lib.getDev ffmpeg}/include"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/obs/obs-plugins/droidcam-obs
    mkdir -p $out/lib/obs-plugins
    cp build/droidcam-obs.so $out/lib/obs-plugins
    cp -R ./data/locale $out/share/obs/obs-plugins/droidcam-obs/locale

    runHook postInstall
  '';

  doCheck = false;

  meta = with lib; {
    description = "DroidCam OBS";
    homepage = "https://github.com/dev47apps/droidcam-obs-plugin";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
