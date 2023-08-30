{ lib, pythonPackages, python3, name, pkgSources, jumanpp, knp }:
let
  inherit (pythonPackages) buildPythonPackage;
in
buildPythonPackage rec {
  inherit (pkgSources."${name}") pname version src;
  patchPhase = ''
    substituteInPlace pyproject.toml \
      --replace 'build-backend = "poetry.masonry.api"' 'build-backend = "poetry.core.masonry.api"'
  '';

  buildInputs = [ jumanpp knp ];

  doCheck = false;
  # for runtime depend
  propagatedBuildInputs = with pythonPackages; [ poetry-core six toml ];

  meta = with lib; {
    homepage = "https://github.com/heavenshell/py-doq";
    description = "Python Module for JUMAN++/KNP";
  };
}
