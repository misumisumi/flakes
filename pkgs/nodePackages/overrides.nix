# Do not use overrides in this file to add  `meta.mainProgram` to packages. Use `./main-programs.nix`
# instead.
{ pkgs, nodejs }:

let
  inherit (pkgs)
    stdenv
    lib
    callPackage
    fetchFromGitHub
    fetchurl
    fetchpatch
    nixosTests;

  since = version: lib.versionAtLeast nodejs.version version;
  before = version: lib.versionOlder nodejs.version version;
in

final: prev: {
  inherit nodejs;

  # Example

  # autoprefixer = prev.autoprefixer.override {
  #   nativeBuildInputs = [ pkgs.buildPackages.makeWrapper ];
  #   postInstall = ''
  #     wrapProgram "$out/bin/autoprefixer" \
  #       --prefix NODE_PATH : ${final.postcss}/lib/node_modules
  #   '';
  #   passthru.tests = {
  #     simple-execution = callPackage ./package-tests/autoprefixer.nix { inherit (final) autoprefixer; };
  #   };
  # };
}
