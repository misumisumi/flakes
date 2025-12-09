{
  lib,
  python3Packages,
  name,
  pkgSources,
  chntpw,
}:
let
  inherit (python3Packages) buildPythonApplication;
in
buildPythonApplication {
  inherit (pkgSources."${name}") pname version src;
  dependencies = [ chntpw ];
  build-system = with python3Packages; [ poetry-core ];

  doCheck = false;
  pyproject = true;

  meta = with lib; {
    homepage = "https://github.com/x2es/bt-dualboot";
    description = "User-friendly tool making your bluetooth devices working both in Windows and Linux without re-pairing chore.";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
