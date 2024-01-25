{ lib, pythonPackages, python3, name, pkgSources }:
let
  inherit (pythonPackages) buildPythonPackage;
in
buildPythonPackage rec {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;
  # for runtime depend
  propagatedBuildInputs = with pythonPackages; [ setuptools_scm notebook nbclassic jupyter-console ];

  meta = with lib; {
    homepage = "https://github.com/kiyoon/jupynium.nvim";
    description = "Control Jupyter Notebook on Neovim with ZERO Compromise";
    license = licenses.mit;
  };
}
