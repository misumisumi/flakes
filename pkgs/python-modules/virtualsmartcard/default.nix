{
  lib,
  fetchFromGitHub,
  nix-update-script,
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
let
  pname = "virtualsmartcard";
  version = "virtualsmartcard-0.10";
in
toPythonModule (
  stdenv.mkDerivation (finalAttrs: {
    inherit pname version;
    src = fetchFromGitHub {
      owner = "frankmorgner";
      repo = "vsmartcard";
      rev = version;
      sha256 = "sha256-+BrX2aqByUvIUbN4K+sdq9bH29FD2rtTt4q+URPgx7A=";
    };
    sourceRoot = "${finalAttrs.src.name}/virtualsmartcard";
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

    passthru.updateScript = nix-update-script {
      extraArgs = [
        "--flake"
        "--version-regex"
        "(virtualsmartcard-*)"
      ];
    };

    meta = with lib; {
      inherit version;
      description = "umbrella project for emulation of smart card readers or smart cards";
      homepage = "https://frankmorgner.github.io/vsmartcard/virtualsmartcard/README.html";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  })
)
