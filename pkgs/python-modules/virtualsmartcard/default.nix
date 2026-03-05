{
  lib,
  pkgSource,
  stdenv,
  autoreconfHook,
  help2man,
  openpace,
  pkg-config,
  python,
  toPythonModule,
  wrapPython,
  pyscard,
  pycryptodome,
  qrencode,
  pcsclite,
}:
toPythonModule (
  stdenv.mkDerivation rec {
    inherit (pkgSource) pname version src;
    sourceRoot = "${src.name}/virtualsmartcard";
    outputs = [
      "out"
      "man"
    ];

    configureFlags = [
      "--enable-serialdropdir=$(out)/pcsc/drivers/serial"
    ];

    nativeBuildInputs = [
      autoreconfHook
      help2man
      pkg-config
      wrapPython
    ];

    dependencies = [
      pycryptodome
      pyscard
      python
    ];

    buildInputs = [
      autoreconfHook
      openpace
      pcsclite
      qrencode
    ];

    postFixup = ''
      wrapPythonPrograms
    '';

    meta = with lib; {
      inherit version;
      description = "umbrella project for emulation of smart card readers or smart cards";
      homepage = "https://frankmorgner.github.io/vsmartcard/virtualsmartcard/README.html";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  }
)
