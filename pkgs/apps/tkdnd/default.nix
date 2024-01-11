# { stdenv, lib, mySource, tc, tcl, alsa-lib, libX11 }:
{ stdenv
, lib
, name
, pkgSources
, cmake
, libXcursor
, tcl
, tk
}: stdenv.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ tk tcl libXcursor ];

  configurePhase = ''
    cd ./cmake
    chmod +x build.sh
    ./build.sh
  '';
  buildPhase = ''
    cd ../cmake/release-nmake-x86_32
    make install
  '';
  installPhase = ''
    mkdir -p $out/lib
    cp -r ../runtime/tkdnd* $out/lib
  '';
  meta = with lib; {
    inherit version;
    description = "TkDND is an extension that adds native drag & drop capabilities to the Tk toolkit.";
    homepage = "https://github.com/petasis/tkdnd";
    license = licenses.free;
  };
}
