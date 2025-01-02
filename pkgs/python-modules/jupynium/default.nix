{
  lib,
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
    coloredlogs
    gitpython
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
    setuptools_scm
    verboselogs
  ];

  meta = with lib; {
    homepage = "https://github.com/kiyoon/jupynium.nvim";
    description = "Control Jupyter Notebook on Neovim with ZERO Compromise";
    license = licenses.mit;
  };
}
