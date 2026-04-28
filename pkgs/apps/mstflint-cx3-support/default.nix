{
  lib,
  fetchurl,
  stdenv,
  libibmad,
  openssl,
  zlib,
}:
let
  version = "4.25.0-1";
in
stdenv.mkDerivation {
  pname = "mstflint-cx3-support";
  inherit version;
  src = fetchurl {
    url = "https://github.com/Mellanox/mstflint/releases/download/v${version}/mstflint-${version}.tar.gz";
    sha256 = "sha256-nYGiWfr8a3q3+bGUb1ovLrAS8/LnEJf+4inIEllW95s=";
  };

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=int-conversion"
    ];
  };
  CFLAGS = "-std=gnu17";
  CXXFLAGS = "-std=c++17";

  buildInputs = [
    libibmad
    openssl
    zlib
  ];

  hardeningDisable = [ "format" ];

  dontDisableStatic = true; # the build fails without this. should probably be reported upstream
  preConfigure = ''
    export CPPFLAGS="-I$(pwd)/tools_layouts"
    export INSTALL_BASEDIR=$out
  '';

  passthru.skipUpdate = true;

  meta = with lib; {
    description = "Open source version of Mellanox Firmware Tools (MFT)";
    homepage = "https://github.com/Mellanox/mstflint";
    license = with licenses; [
      gpl2
      bsd2
    ];
    platforms = platforms.linux;
  };
}
