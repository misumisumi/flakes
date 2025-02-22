{
  python3Packages,
  name,
  pkgSources,
}:
let
  inherit (python3Packages) buildPythonPackage;
in
buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;
  pyproject = true;
  # for runtime depend
  propagatedBuildInputs = with python3Packages; [
    hatchling
    hatch-requirements-txt
    tomli
  ];

  meta = {
    homepage = "https://github.com/kiyoon/version-pioneer";
    description = "Versioneer fork with hatchling, pdm support with useful CLI. Manage git tag-based version for any project.";
  };
}
