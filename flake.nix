{
  description = "Packages without nixpkgs using by Sumi-Sumi";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nvfetcher.url = "github:berberman/nvfetcher";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    let
      inherit (inputs.nixpkgs) lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      imports = [
        inputs.devshell.flakeModule
      ];
      flake = rec {
        nixosModules.default = import ./modules/nixos;
        homeManagerModules.default = import ./modules/home-manager;

        overlay = overlays.default; # deprecated attributes for retro compatibility
        overlays.default =
          final: prev:
          (import ./pkgs/overrides { inherit final prev; })
          // (import ./pkgs/apps {
            inherit lib;
            pkgs = final;
          }).override
          // {
            pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
              (
                pfinal: pprev:
                (import ./pkgs/python-modules {
                  inherit lib;
                  pkgs = final;
                }).override
                // {
                  mcp = pprev.mcp.overridePythonAttrs (old: {
                    postPatch = prev.lib.optionalString prev.stdenv.buildPlatform.isDarwin ''
                      # time.sleep(0.1) feels a bit optimistic and it has been flaky whilst
                      # testing this on macOS under load.
                      substituteInPlace \
                        "tests/shared/test_ws.py" \
                        "tests/shared/test_sse.py" \
                        --replace-fail "time.sleep(0.5)" "time.sleep(1)"
                      substituteInPlace \
                        "tests/client/test_stdio.py" \
                        --replace-fail "time.sleep(0.1)" "time.sleep(1)"
                    '';
                  });
                }
              )
            ];
            python3 =
              let
                self = prev.python3.override {
                  inherit self;
                  packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
                };
              in
              self;
            python3Packages = final.python3.pkgs;
          }
          // {
            zotero-addons =
              (import ./pkgs/zotero-addons {
                inherit (prev)
                  lib
                  fetchurl
                  nix-update-script
                  stdenv
                  ;
              }).override;
          };
      };
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      perSystem =
        {
          system,
          pkgs,
          lib,
          ...
        }:
        let
          inherit (import ./lib.nix { inherit lib; }) mkCheck mkPackages;
          myPkgs =
            (
              (import ./pkgs/apps {
                inherit lib;
                inherit pkgs;
              }).packages
              pkgs
            )
            // (
              (import ./pkgs/python-modules {
                inherit lib;
                inherit pkgs;
              }).packages
              pkgs
            )
            // (
              (import ./pkgs/zotero-addons {
                inherit lib;
                inherit (pkgs)
                  fetchurl
                  nix-update-script
                  stdenv
                  ;
              }).packages
              pkgs
            );
          nix-update = pkgs.nix-update.overrideAttrs (old: {
            postPatch = old.postPatch or "" + ''
              substituteInPlace nix_update/eval.nix \
                --replace-fail "pkg.npmDeps.outputHash or null" "if pkg ? npmDeps then pkg.npmDeps.outputHash or true else null"
            '';
          });
        in
        rec {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
              inputs.nvfetcher.overlays.default
            ];
            config.allowUnfree = true;
          };
          apps = {
            update-pkgs = import ./scripts/update-pkgs.nix {
              inherit lib packages nix-update;
              inherit (pkgs) writeShellScriptBin python3;
            };
          };
          packages = (mkPackages system myPkgs) // {
            inherit nix-update;
          };
          checks = mkCheck packages;
          devshells.default = {
            packages = with pkgs; [
              bashInteractive
              nix-index # A files database for nixpkgs
              nix-prefetch # Prefetch checkers
              nix-prefetch-git
              nix-prefetch-github
              nvfetcher # Tool of automate nix package updates
              prefetch-npm-deps
              prefetch-yarn-deps
            ];
          };
        };
    };
}
