{ stdenv,
  lib,
  rustPlatform,
  name,
  pkgSources,
  git,
  cargo,
  rustc,
  rustfmt,
  libusb1,
  systemd,
  freetype,
  expat,
  fontconfig,
  pkg-config, 
  power-profiles-daemon,
  libappindicator-gtk3
}:

rustPlatform.buildRustPackage rec {
  inherit (pkgSources."${name}") pname version src;
  cargoLock = pkgSources."${name}".cargoLock."Cargo.lock";

  buildInputs = [ git cargo rustc rustfmt systemd libusb1 freetype expat fontconfig pkg-config libappindicator-gtk3];
  nativeBuildInputs = [ pkg-config power-profiles-daemon ];

  doCheck = false;

  buildPhase = ''
    make
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
