{
  lib,
  name,
  pkgSources,
  buildPythonPackage,
  hatchling,
  hatch-requirements-txt,
  tomli,
}:
buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;

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
