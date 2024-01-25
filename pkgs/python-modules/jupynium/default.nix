{ lib, pythonPackages, python3, name, pkgSources }:
let
  inherit (pythonPackages) buildPythonPackage;
in
buildPythonPackage rec {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;
  # for runtime depend
  propagatedBuildInputs = with pythonPackages; [
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
