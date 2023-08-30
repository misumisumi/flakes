{ lib
, pythonPackages
, name
, pkgSources
, openai
, patchelf
,
}:
let
  inherit (pythonPackages) buildPythonPackage;
in
buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;

  nativeBuildInputs = [ patchelf ];

  doCheck = false;
  # for runtime depend
  propagatedBuildInputs = [ openai ];
  postInstall = ''
    patchelf --set-interpreter ''$(cat ''$NIX_CC/nix-support/dynamic-linker) $out/lib/python*/site-packages/speech_recognition/flac-linux-x86_64
    patchelf --set-interpreter ''$(cat ''$NIX_CC/nix-support/dynamic-linker) $out/lib/python*/site-packages/speech_recognition/flac-linux-x86
  '';

  meta = with lib; {
    homepage = "https://github.com/Uberi/speech_recognition";
    description = "Speech recognition module for Python, supporting several engines and APIs, online and offline.";
  };
}
