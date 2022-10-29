{ lib, pythonPackages, name, pkgSources }:
let
  inherit (pythonPackages) buildPythonPackage;
in buildPythonPackage rec {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/heavenshell/py-doq";
    description = "Docstring generator";
    license = licenses.bsd3;
  };
}
