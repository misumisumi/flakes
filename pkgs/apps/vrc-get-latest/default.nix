{ stdenv
, lib
, name
, pkgSources
, rustPlatform
, pkg-config
, openssl
  # , Security
}:

rustPlatform.buildRustPackage {
  inherit (pkgSources."${name}") pname version src;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]; #  ++ lib.optionals stdenv.isDarwin [ Security ];

  # Make openssl-sys use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  cargoLock = pkgSources."${name}".cargoLock."Cargo.lock";

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/anatawa12/vrc-get";
    license = licenses.mit;
  };
}
