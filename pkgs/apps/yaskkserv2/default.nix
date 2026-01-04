{
  lib,
  rustPlatform,
  name,
  pkgSources,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage {
  inherit (pkgSources."${name}") pname version src;
  cargoLock = pkgSources."${name}".cargoLock."Cargo.lock";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  doCheck = false;

  patchPhase = ''
    substituteInPlace src/skk/mod.rs \
      --replace /etc/yaskkserv2.conf $out/etc/yaskkserv2.conf
  '';

  buildPhase = ''
    cargo build --release
  '';

  installPhase = ''
    mkdir -p $out/{etc,bin}
    cp -av etc/yaskkserv2.conf $out/etc
    cp -av target/release/yaskkserv2 $out/bin
    cp -av target/release/yaskkserv2_make_dictionary $out/bin
  '';

  meta = with lib; {
    description = "skkserv wroten by rust";
    homepage = "https://github.com/wachikun/yaskkserv2";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
