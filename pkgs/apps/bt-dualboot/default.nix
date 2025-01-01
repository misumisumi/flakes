{
  lib,
  python3Packages,
  name,
  pkgSources,
  chntpw,
  fetchpatch,
}:
let
  inherit (python3Packages) buildPythonApplication;
  _chntpw = chntpw.overrideAttrs (oldAttrs: {

    patches = oldAttrs.patches ++ [
      (fetchpatch {
        name = "17_hexdump-pointer-type.patch";
        url = "https://git.launchpad.net/ubuntu/+source/chntpw/plain/debian/patches/17_hexdump-pointer-type.patch?id=aed501c87499f403293e7b9f505277567c2f3b52";
        sha256 = "sha256-ir9LFl8FJq141OwF5SbyVMtjQ1kTMH1NXlHl0XZq7m8=";
      })
    ];
  });
in
buildPythonApplication {
  inherit (pkgSources."${name}") pname version src;
  dependencies = [ _chntpw ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/x2es/bt-dualboot";
    description = "User-friendly tool making your bluetooth devices working both in Windows and Linux without re-pairing chore.";
    license = licenses.mit;
  };
}
