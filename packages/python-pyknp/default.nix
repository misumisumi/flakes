{ lib, pythonPackages, python3, name, pkgSources }:
let
  inherit (pythonPackages) buildPythonPackage;
in buildPythonPackage rec {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;
  # for runtime depend
  propagatedBuildInputs = with pythonPackages; [ toml poetry ];

  meta = with lib; {
    homepage = "https://github.com/heavenshell/py-doq";
    description = "Python Module for JUMAN++/KNP";
  };
}
