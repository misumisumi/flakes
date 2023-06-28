{
  lib,
  pythonPackages,
  name,
  pkgSources,
  flac,
  openai,
}: let
  inherit (pythonPackages) buildPythonPackage;
in
  buildPythonPackage rec {
    inherit (pkgSources."${name}") pname version src;

    doCheck = false;
    # for runtime depend
    propagatedBuildInputs = [flac openai];

    meta = with lib; {
      homepage = "https://github.com/Uberi/speech_recognition";
      description = "Speech recognition module for Python, supporting several engines and APIs, online and offline.";
    };
  }