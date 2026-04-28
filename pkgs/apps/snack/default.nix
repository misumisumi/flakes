{
  lib,
  fetchurl,
  stdenv,
  writeScript,
  alsa-lib,
  curl,
  libX11,
  tcl,
  tk,
}:
let
  pname = "snack";
  version = "2.2.10";
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchurl {
    url = "http://www.speech.kth.se/${pname}/dist/${pname}${version}.tar.gz";
    sha256 = "sha256-S/52RUerkrpY9Dt3Nm27fHs1EtZaJ82/nlhanLZM6B4=";
  };

  buildInputs = [
    alsa-lib
    libX11
    tk
    tcl
  ];
  patches = [
    ./alsa.patch
    ./archbuild.patch
    ./args.patch
    ./CVE-2012-6303.patch
    ./formant.patch
    ./libs.patch
    ./seektell.patch
    ./tksnack.patch
  ];

  preConfigure = ''
    sed -i -e 's|^\(#define roundf(.*\)|//\1|' generic/jkFormatMP3.c
    cd unix
  '';

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--enable-alsa"
  ];
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=implicit-int"
    "-Wno-error=incompatible-pointer-types"
    "-std=gnu17"
  ];

  hardeningDisable = [ "format" ];

  installFlags = [ "DESTDIR=$(out)" ];

  passthru = {
    updateScript = writeScript "snack-patch-update" ''
      #!${stdenv.shell}
      set -eu -o pipefail

      pushd pkgs/apps/snack

      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/alsa.patch?h=snack" -o alsa.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/archbuild.patch?h=snack" -o archbuild.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/args.patch?h=snack" -o args.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/CVE-2012-6303.patch?h=snack" -o CVE-2012-6303.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/formant.patch?h=snack" -o formant.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/libs.patch?h=snack" -o libs.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/seektell.patch?h=snack" -o seektell.patch
      ${curl}/bin/curl --fail --retry 5 --retry-all-errors --retry-delay 10 "https://aur.archlinux.org/cgit/aur.git/plain/tksnack.patch?h=snack" -o tksnack.patch

      popd
    '';
  };

  meta = with lib; {
    description = "a sound toolkit for scripting languages (Tcl, Python, Ruby, ...)";
    homepage = "http://www.speech.kth.se/snack/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };

}
