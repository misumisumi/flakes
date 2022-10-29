{ lib, pythonPackages, name, pkgSources }:

pythonPackages.buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/heavenshell/py-doq";
    description = "Docstring generator";
    license = licenses.bsd3;
  };
}
