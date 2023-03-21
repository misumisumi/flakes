# { stdenv, lib, mySource, tc, tcl, alsa-lib, libX11 }:
{ stdenv, lib, fetchpatch, name, pkgSources, alsa-lib, libX11, tk, tcl }:
stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;

  nativeBuildInputs = [ alsa-lib libX11 tk tcl ];
  patches = [
    (fetchpatch {
      name = "alsa.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/alsa.patch?h=snack";
      sha256 = "sha256-0BC/uu7QGMxHuYGBgdY9n07LeyPgqzD7RWVLGM5/EF8=";
     })
  ];
  patchPhase = ''
    for i in $patches ; do
      patch -p0 < $i
    done
  '';

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
