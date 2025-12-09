{
  stdenv,
  lib,
  name,
  pkgSources,
  alsa-lib,
  perl,
  pkg-config,
  zlib,
  SDL2,
}:
stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;
  nativeBuildInputs = [ pkg-config ];
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
    inherit version;
    description = "Open-Source Large Vocabulary Continuous Speech Recognition Engine";
    homepage = "https://github.com/julius-speech/julius";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
  };
}
