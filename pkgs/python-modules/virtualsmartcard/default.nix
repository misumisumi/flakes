{
  stdenv,
  lib,
  name,
  autoreconfHook,
  help2man,
  openpace,
  pkg-config,
  pkgSources,
  python3Packages,
  qrencode,
  pcsclite,
}:
let
  inherit (python3Packages) python;
  inherit (python3Packages.python.pkgs) pyscard pycryptodome;
  inherit (python3Packages) toPythonModule wrapPython;
in
toPythonModule (
  stdenv.mkDerivation rec {
    inherit (pkgSources."${name}") pname version src;
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

    propagatedBuildInputs = [
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

    # postInstall = ''
    #   mv $out/var/lib/pcsc $out/
    #   rm -rf $out/var
    # '';

    postFixup = ''
      wrapPythonPrograms
    '';

    meta = with lib; {
      inherit version;
      description = "umbrella project for emulation of smart card readers or smart cards";
      homepage = "https://frankmorgner.github.io/vsmartcard/virtualsmartcard/README.html";
      license = licenses.gpl3;
    };
  }
)
