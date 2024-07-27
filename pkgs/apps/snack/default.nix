# { stdenv, lib, mySource, tc, tcl, alsa-lib, libX11 }:
{ stdenv
, lib
, fetchpatch
, name
, pkgSources
, alsa-lib
, libX11
, tcl
, tk
}:
stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;

  buildInputs = [ alsa-lib libX11 tk tcl ];
  patches = [
    (fetchpatch {
      name = "alsa.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/alsa.patch?h=snack";
      sha256 = "sha256-7VqIlQwPvNLMJ766TzgKKWdd3WK9TaSmoYsdZz0h9bE=";
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

  hardeningDisable = [ "format" ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    inherit version;
    description = "a sound toolkit for scripting languages (Tcl, Python, Ruby, ...)";
    homepage = "http://www.speech.kth.se/snack/";
    license = licenses.gpl2;
  };

}
