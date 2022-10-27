# { stdenv, lib, mySource, tc, tcl, alsa-lib, libX11 }:
{ stdenv, lib, name, pkgSources, tk, tcl, alsa-lib, libX11 }:

stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;

  nativeBuildInputs = [ tk tcl alsa-lib libX11 ];

  preConfigure = ''
    sed -i -e 's|^\(#define roundf(.*\)|//\1|' generic/jkFormatMP3.c
    cd unix
  '';

  configureFlags = [
    "--prefix=$out" 
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--enable-alsa"
  ];

  hardeningDisable = [ "format" ];

  installPhase = ''
    make DESTDIR=$out install
  '';

  meta = with lib; {
    inherit version;
    description = "a sound toolkit for scripting languages (Tcl, Python, Ruby, ...)";
    homepage = "http://www.speech.kth.se/snack/";
    license = licenses.gpl2;
  };

}
