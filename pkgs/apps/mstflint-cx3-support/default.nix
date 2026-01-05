{
  name,
  pkgSources,
  lib,
  stdenv,
  libibmad,
  openssl,
  zlib,
}:
stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;

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
