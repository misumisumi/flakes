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
    nixosTests
    ;

  since = version: lib.versionAtLeast nodejs.version version;
  before = version: lib.versionOlder nodejs.version version;
in

final: prev: {
  inherit nodejs;

  "@commitlint/config-lerna-scopes" = prev."@commitlint/config-lerna-scopes".overrideAttrs (old: {
    # nativeBuildInputs = [ pkgs.bash ];
    buildInputs = old.buildInputs ++ [ pkgs.nodePackages.napi-postinstall ];
  });

}
