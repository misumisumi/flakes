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
      inherit (import ./lib.nix { inherit (inputs.nixpkgs) lib; })
        mkApps
        mkCheck
        names
        runnableApps
        sources
        pkgSourcesJSON
        withContents
        ;

      appsDir = ./pkgs/apps;
      pythonModulesDir = ./pkgs/python-modules;
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
          let
            pkgSources = sources final;
            override =
              name: pkg:
              builtins.intersectAttrs (builtins.functionArgs pkg) {
                inherit name pkgSources pkgSourcesJSON;
                pythonPackages = final.python3.pkgs;
              };
          in
          withContents appsDir (
            name:
            let
              app = import (appsDir + "/${name}");
            in
            final.callPackage app (override name app)
          )
          // import ./pkgs/overrides/default.nix { inherit final prev; }
          // {
            sources = pkgSources;
          }
          // {
            pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
              (
                pfinal: pprev:
                withContents pythonModulesDir (
                  name:
                  let
                    module = import (pythonModulesDir + "/${name}");
                  in
                  pfinal.callPackage module (override name module)
                )
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
            nodePackages =
              prev.nodePackages
              // import ./pkgs/node-packages {
                inherit (prev)
                  config
                  pkgs
                  lib
                  nodejs
                  stdenv
                  ;
              };
          }
          // prev.lib.mapAttrs' (
            name: value: prev.lib.nameValuePair value final.nodePackages.${name}
          ) (import ./pkgs/node-packages/main-programs.nix)
          // {
            zotero-addons = import ./pkgs/zotero-addons {
              inherit (prev)
                fetchgit
                fetchurl
                fetchFromGitHub
                dockerTools
                lib
                stdenv
                ;
            };
          };
      };
      systems = [ "x86_64-linux" ];
      perSystem =
        {
          system,
          pkgs,
          lib,
          ...
        }:
        rec {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
              inputs.nvfetcher.overlays.default
            ];
            config.allowUnfree = true;
          };
          packages =
            withContents appsDir (name: pkgs.${name})
            // withContents pythonModulesDir (name: pkgs.python3Packages.${name})
            // lib.listToAttrs (
              map (name: {
                name = "nodePackages.${name}";
                value = pkgs.nodePackages.${name};
              }) (with builtins; fromJSON (readFile ./pkgs/node-packages/node-packages.json))
            )
            // lib.mapAttrs' (
              name: value: lib.nameValuePair "zotero-addons.${name}" pkgs.zotero-addons.${name}
            ) (with builtins; fromJSON (readFile ./pkgs/zotero-addons/_sources/generated.json))
            // lib.mapAttrs' (
              name: value: lib.nameValuePair value pkgs.${value}
            ) (import ./pkgs/node-packages/main-programs.nix)
            // import ./env.nix { inherit pkgs; };
          apps = mkApps pkgs (runnableApps pkgs (names appsDir));
          checks = mkCheck packages;
          devShells =
            withContents appsDir (
              name:
              (pkgs.${name}.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.bashInteractive ];
              }))
            )
            // withContents pythonModulesDir (
              name:
              (pkgs.python3Packages.${name}.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.bashInteractive ];
              }))
            );
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
