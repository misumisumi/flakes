{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-requirements-txt,
  tomli,
}:
let
  version = "0.0.16";
in
buildPythonPackage {
  pname = "version_pioneer";
  inherit version;
  src = fetchPypi {
    pname = "version_pioneer";
    inherit version;
    sha256 = "sha256-AdJ90fhZraBxc7dU1ckpB0TtBE56dZWaPXpFjwgRvKg=";
  };

  doCheck = false;
  pyproject = true;
  # for runtime depend
  dependencies = [
    hatchling
    hatch-requirements-txt
    tomli
  ];

  meta = {
    homepage = "https://github.com/kiyoon/version-pioneer";
    description = "Versioneer fork with hatchling, pdm support with useful CLI. Manage git tag-based version for any project.";
    platforms = lib.platforms.all;
  };
}
