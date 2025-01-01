# { stdenv, lib, mySource, tc, tcl, alsa-lib, libX11 }:
{
  stdenv,
  lib,
  fetchpatch,
  name,
  pkgSources,
  alsa-lib,
  libX11,
  tcl,
  tk,
}:
stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;

  buildInputs = [
    alsa-lib
    libX11
    tk
    tcl
  ];
  patches = [
    (fetchpatch {
      name = "alsa.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/alsa.patch?h=snack";
      sha256 = "sha256-7VqIlQwPvNLMJ766TzgKKWdd3WK9TaSmoYsdZz0h9bE=";
    })
    (fetchpatch {
      name = "archbuild.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/archbuild.patch?h=snack";
      sha256 = "sha256-ohCv6aVcc30mIahwPEr1hG/Wh+alVrePshvBTFlq/tM=";
    })
    (fetchpatch {
      name = "args.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/args.patch?h=snack";
      sha256 = "sha256-+OdNZXJLw35RXryBkrM+8r6/l9uq39O+KBLIs4poYXI=";
    })
    (fetchpatch {
      name = "CVE-2012-6303.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/CVE-2012-6303.patch?h=snack";
      sha256 = "sha256-FaP077XXIx745HP/l2DtYju2FF0cjy2ukQIAwAbaLjs=";
    })
    (fetchpatch {
      name = "formant.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/formant.patch?h=snack";
      sha256 = "sha256-Hax3jrbk2oIsgZ1zagRPz0b45/XHYurFZLFX98Ioupo=";
    })
    (fetchpatch {
      name = "libs";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/libs.patch?h=snack";
      sha256 = "sha256-M3/UE6InacPmfnTawXc4ejaEYLzNMFQU72KGKCeFnKo=";
    })
    (fetchpatch {
      name = "seektell";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/seektell.patch?h=snack";
      sha256 = "sha256-yBCMgU6WXsayVoPxFyx038bQWHVrkNmyU1uFrqTAnQo=";
    })
    (fetchpatch {
      name = "tksnack";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/tksnack.patch?h=snack";
      sha256 = "sha256-4/uGhDF/tUClKp45sPgXtsx9cBJ+WlQwzXz7JyXfFOs=";
    })
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
  ];

  hardeningDisable = [ "format" ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    inherit version;
    description = "a sound toolkit for scripting languages (Tcl, Python, Ruby, ...)";
    homepage = "http://www.speech.kth.se/snack/";
    license = licenses.gpl2;
  };

}
