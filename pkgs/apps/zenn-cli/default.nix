# From
{ name, pkgSources, buildNodePackage }:
buildNodePackage {
  inherit (pkgSources) name version src;
  production = true;
  bypassCache = true;
  reconstructLock = true;
}
