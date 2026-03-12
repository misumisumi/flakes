{
  pkgSource,
  lib,
  stdenv,
  SDL2,
  alsa-lib,
  perl,
  pkg-config,
  zlib,
}:
stdenv.mkDerivation {
  inherit (pkgSource) pname src;
  version = lib.removePrefix "v" pkgSource.version;

  env.NIX_CFLAGS_COMPILE = toString [
    "-std=gnu17"
    "-Wno-error=implicit-function-declaration"
  ];

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    SDL2
    perl
    zlib
  ];

  prePatch = ''
    grep -l -E -r "#!/usr/bin/perl" ./ | while read f; do
      substituteInPlace $f --replace "#!/usr/bin/perl" "#!${perl}/bin/perl"
    done
  '';
  configurePhase = ''
    ./configure --enable-words-int --prefix=$out
  '';

  meta = with lib; {
    description = "Open-Source Large Vocabulary Continuous Speech Recognition Engine";
    homepage = "https://github.com/julius-speech/julius";
    license = licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
