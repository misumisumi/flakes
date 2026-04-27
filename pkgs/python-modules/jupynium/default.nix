{
  lib,
  fetchPypi,
  buildPythonPackage,
  coloredlogs,
  gitpython,
  hatch-requirements-txt,
  hatchling,
  jupyter-console,
  nbclassic,
  notebook,
  packaging,
  persist-queue,
  platformdirs,
  psutil,
  pynvim,
  selenium,
  setuptools,
  setuptools-scm,
  verboselogs,
  version-pioneer,
}:
let
  pname = "jupynium";
  version = "0.2.7";
in
buildPythonPackage {
  inherit pname version;
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fZtSND4uy5vja09a4ZshFElZIdonNzxAZIqXQABrPUM=";
  };

  doCheck = false;
  pyproject = true;
  # for runtime depend
  dependencies = [
    coloredlogs
    gitpython
    hatch-requirements-txt
    hatchling
    jupyter-console
    nbclassic
    notebook
    packaging
    persist-queue
    platformdirs
    psutil
    pynvim
    selenium
    setuptools
    setuptools-scm
    verboselogs
    version-pioneer
  ];
  passthru.useUpdateScript = false;

  meta = with lib; {
    homepage = "https://github.com/kiyoon/jupynium.nvim";
    description = "Control Jupyter Notebook on Neovim with ZERO Compromise";
    license = licenses.mit;
    platforms = lib.platforms.all;
  };
}
