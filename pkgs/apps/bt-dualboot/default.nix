{
  lib,
  fetchPypi,
  python3Packages,
  chntpw,
}:
let
  inherit (lib) licenses;
  inherit (python3Packages) buildPythonApplication;

  pname = "bt-dualboot";
  version = "1.0.1";
in
buildPythonApplication {
  inherit pname version;
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pjzGvLkotQllzyrnxqDIjGlpBOvUPkWpv0eooCUrgv8=";
  };
  dependencies = [ chntpw ];
  build-system = with python3Packages; [ poetry-core ];

  doCheck = false;
  pyproject = true;

  meta = {
    homepage = "https://github.com/x2es/bt-dualboot";
    description = "User-friendly tool making your bluetooth devices working both in Windows and Linux without re-pairing chore.";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
