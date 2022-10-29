{ lib, pythonPackages, name, pkgSources }:

pythonPackages.buildPythonPackage rec {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/heavenshell/py-doq";
    description = "Docstring generator";
    license = licenses.bsd3;
  };
}
