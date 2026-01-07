{
  lib,
  name,
  pkgSources,
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
buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;

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

  meta = with lib; {
    homepage = "https://github.com/kiyoon/jupynium.nvim";
    description = "Control Jupyter Notebook on Neovim with ZERO Compromise";
    license = licenses.mit;
    platforms = lib.platforms.all;
  };
}
