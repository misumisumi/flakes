{ pkgs
, stdenv
, buildEnv
, nodejs
, nodePackages
, makeWrapper
, extraModule ? [ ]
}:
let
  extraNodePackages = import ../../nodePackages/composition.nix {
    inherit pkgs nodejs; inherit (stdenv.hostPlatform) system;
  };
  modules = [ "@commitlint/cli" "@commitlint/config-conventional" "commitlint-format-json" ];
in
buildEnv {
  nativeBuildInputs = [ makeWrapper ];
  name = "commitlint";
  paths = (map (x: nodePackages."${x}") modules) ++ (map (x: extraNodePackages."${x}") extraModule);
  pathsToLink = [
    "/bin"
    "/lib/node_modules"
  ];
  postBuild = ''
    wrapProgram "$out/bin/commitlint" \
      --set NODE_PATH "$out/lib/node_modules"
  '';
}
