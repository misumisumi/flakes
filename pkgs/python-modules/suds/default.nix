{ name
, pkgSources
, lib
, pythonPackages
}:
pythonPackages.buildPythonPackage rec {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/suds-community/suds";
    description = "A lightweight SOAP-based web service client for Python licensed under LGPL ";
    license = licenses.lgpl3;
  };
}
