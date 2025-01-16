{
  stdenv,
  lib,
  name,
  pkgSources,
  autoreconfHook,
  gengetopt,
  help2man,
  openssl,
  pkg-config,
}:
stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;
  outputs = [
    "bin"
    "dev"
    "out"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    help2man
    gengetopt
  ];

  buildInputs = [
    openssl
  ];

  postInstall = ''
    rm -f $bin/bin/example
  '';

  meta = with lib; {
    inherit version;
    description = "Cryptographic library for EAC version 2";
    homepage = "https://frankmorgner.github.io/openpace/index.html";
    license = licenses.gpl3;
  };
}
