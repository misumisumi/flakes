# From
{ name, pkgSources, pkgs, nodejs }:
let
  nodeEnv = import ../../node-packages/node-env.nix {
    inherit (pkgs) stdenv lib python2 runCommand writeTextFile writeShellScript;
    inherit pkgs nodejs;
    libtool = null;
  };
  inherit (pkgSources."${name}") pname version src;
in
nodeEnv.buildNodePackage rec {
  inherit version src;
  name = pname;
  packageName = pname;
  production = true;
  bypassCache = true;
  reconstructLock = true;
}
