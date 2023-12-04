{ lib
, ...
}:
let
  ls = path: builtins.readDir path;
  # From https://github.com/numtide/flake-utils
  mkApp =
    { drv
    , name ? drv.pname or drv.name
    , exePath ? drv.passthru.exePath or "/bin/${name}"
    ,
    }: {
      type = "app";
      program = "${drv}${exePath}";
    };
  # For nix run
  isRunnableApp = pkgs: name:
    if pkgs.${name}.passthru.runnable or false
    then name
    else false;
  isDir = ts: t:
    if ts.${t} == "directory"
    then t
    else false;
  genPkg = func: name: {
    inherit name;
    value = func name;
  };
  genApp = pkgs: name: {
    inherit name;
    value = mkApp { drv = pkgs.${name}; };
  };
  broken = import ./pkgs/broken.nix;
  dontcheck = import ./pkgs/dontcheck.nix;
in
rec {
  mkApps = pkgs: appNames: lib.listToAttrs (map (genApp pkgs) appNames);
  mkCheck = pkgs: lib.filterAttrs (n: v: (lib.all (x: n != x) dontcheck)) pkgs;
  names = targetDir: lib.subtractLists broken (lib.remove false (map (isDir (ls targetDir)) (lib.attrNames (ls targetDir))));
  runnableApps = pkgs: ts: lib.remove false (map (isRunnableApp pkgs) ts);
  sources = pkgs: import ./_sources/generated.nix { inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools; };
  # Make { appName = import ./<appName> }
  withContents = targetDir: func: lib.listToAttrs (map (genPkg func) (names targetDir));
}
