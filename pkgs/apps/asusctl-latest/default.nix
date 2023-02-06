{ stdenv
, lib
, rustPlatform
, name
, pkgSources
, expat
, fontconfig
, freetype
, libappindicator-gtk3
, libusb1
, pkg-config
, power-profiles-daemon
, systemd
}:

rustPlatform.buildRustPackage rec {
  inherit (pkgSources."${name}") pname version src;
  cargoLock = pkgSources."${name}".cargoLock."Cargo.lock";

  buildInputs = [ expat fontconfig freetype libappindicator-gtk3 libusb1 power-profiles-daemon systemd ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = false;
  buildPhase = ''
    make -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir -p $out/tmp
    make DESTDIR=$out/tmp install
    mv $out/tmp/usr/* $out/
    mv $out/tmp/etc $out/
    rm -r $out/tmp
  '';

  meta = with lib; {
    inherit version;
    description = "A control daemon, CLI tools, and a collection of crates for interacting with ASUS ROG laptops";
    homepage = "https://asus-linux.org/";
    license = licenses.mpl20;
  };
}
