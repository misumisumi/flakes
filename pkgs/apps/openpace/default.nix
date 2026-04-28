{
  lib,
  fetchFromGitHub,
  stdenv,
  autoreconfHook,
  gengetopt,
  help2man,
  openssl,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "openpace";
  version = "1.1.4";
  src = fetchFromGitHub {
    owner = "frankmorgner";
    repo = "openpace";
    rev = "1.1.4";
    sha256 = "sha256-S3YlVeovjcew72nrydBhd1A1scpk5tSw3CPIKm4aBaU=";
  };
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
    description = "Cryptographic library for EAC version 2";
    homepage = "https://frankmorgner.github.io/openpace/index.html";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
