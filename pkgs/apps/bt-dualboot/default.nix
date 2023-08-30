{ lib
, pythonPackages
, python3
, name
, pkgSources
, chntpw
,
}:
let
  inherit (pythonPackages) buildPythonApplication;
in
buildPythonApplication rec {
  inherit (pkgSources."${name}") pname version src;
  nativeBuildInputs = [ chntpw ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/x2es/bt-dualboot";
    description = "User-friendly tool making your bluetooth devices working both in Windows and Linux without re-pairing chore.";
    license = licenses.mit;
  };
}
