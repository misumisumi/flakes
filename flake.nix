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
                  fastmcp-slim = pprev.fastmcp-slim.override {
                    mcp = pprev.mcp_1;
                  };
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
              inherit lib packages;
              inherit (pkgs) nix-update writeShellScriptBin;
            };
            update-pkgs-hashes = import ./scripts/update-pkgs.nix {
              inherit lib packages;
              inherit (pkgs) nix-update writeShellScriptBin;
              hashOnly = true;
            };
          };
          packages = mkPackages system myPkgs;
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
