{
  python3Packages,
  name,
  pkgSources,
  jumanpp,
  knp,
}:
let
  inherit (python3Packages) buildPythonPackage;
in
buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;
  patchPhase = ''
    substituteInPlace pyproject.toml \
      --replace 'build-backend = "poetry.masonry.api"' 'build-backend = "poetry.core.masonry.api"'
  '';

  buildInputs = [
    jumanpp
    knp
  ];

  doCheck = false;
  # for runtime depend
  propagatedBuildInputs = with python3Packages; [
    poetry-core
    six
    toml
  ];

  meta = {
    homepage = "https://github.com/ku-nlp/pyknp";
    description = "Python Module for JUMAN++/KNP";
  };
}
