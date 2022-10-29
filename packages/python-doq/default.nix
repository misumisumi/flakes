{ lib, buildPythonPackage, name, pkgSources }:

buildPythonPackage rec {
  inherit (pkgSources."${name}") pname version src;

  format = "setuptools";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/heavenshell/py-doq";
    description = "Docstring generator";
    license = licenses.bsd3;
  };
}
