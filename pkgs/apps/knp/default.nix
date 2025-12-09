{
  stdenv,
  lib,
  name,
  pkgSources,
  fetchurl,
  autoconf,
  automake,
  libtool,
  perl,
  unzip,
  zlib,
}:
stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;
  buildInputs = [
    autoconf
    automake
    libtool
    perl
    unzip
    zlib
  ];
  dict4knp = fetchurl {
    url = "http://lotus.kuee.kyoto-u.ac.jp/nl-resource/knp/dict/latest/knp-dict-latest-bin.zip";
    sha256 = "0sagr41gh1hx0i22h3s8kjwb5g9qc46hv2fxvswjh8c1fwknqpxl";
  };

  hardeningDisable = [ "format" ]; # remove "-Werror=format-security" from gcc flag

  env.NIX_CFLAGS_COMPILE = toString [
    "-fcommon" # Multi linkerでもビルドできるようにする
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=implicit-int"
    "-Wno-error=incompatible-pointer-types"
    "-Wno-error=int-conversion"
  ];

  patches = [
    ./Makefile.patch
    ./system_Makefile.patch
  ];
  prePatch = ''
    substituteInPlace ./rule/rule2data.pl \
      --replace "/usr/bin/env perl" "${perl}/bin/perl"
    substituteInPlace ./rule/phrase2rule.pl \
      --replace "/usr/bin/env perl" "${perl}/bin/perl"
  '';
  configurePhase = ''
    ./autogen.sh
    unzip $dict4knp -d tmp
    cp -r ./tmp/dict-bin/* ./dict
    ./configure --prefix=$out
  '';

  meta = with lib; {
    inherit version;
    description = "plugin for droidcam obs";
    homepage = "https://github.com/dev47apps/droidcam-obs-plugin";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
