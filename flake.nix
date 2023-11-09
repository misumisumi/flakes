{
  description = "Packages without nixpkgs using by Sumi-Sumi";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs @ { self
    , flake-parts
    , ...
    }:
    let
      inherit (import ./lib.nix { inherit (inputs.nixpkgs) lib; }) mkApps mkCheck names runnableApps sources withContents;

      appsDir = ./pkgs/apps;
      pythonModulesDir = ./pkgs/python-modules;
    in
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        flake = rec {
          nixosModules = {
            for-nixos = import ./modules/for-nixos.nix;
            for-hm = import ./modules/for-hm.nix;
          };
          overlay = overlays.default; # deprecated attributes for retro compatibility
          overlays.default = final: prev:
            let
              pkgSources = sources final;
              override = name: pkg:
                builtins.intersectAttrs (builtins.functionArgs pkg) {
                  inherit name pkgSources;
                  pythonPackages = final.python3.pkgs;
                };
            in
            withContents appsDir
              (
                name:
                let
                  app = import (appsDir + "/${name}");
                in
                final.callPackage app (override name app)
              )
            // {
              sources = pkgSources;
            }
            // {
              pythonPackagesOverlays =
                (prev.pythonPackagesOverlays or [ ])
                ++ [
                  (pfinal: pprev:
                    withContents pythonModulesDir (
                      name:
                      let
                        module = import (pythonModulesDir + "/${name}");
                      in
                      pfinal.callPackage module (override name module)
                    ))
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
            };
        };
        systems = [ "x86_64-linux" "aarch64-linux" ];
        perSystem = { system, pkgs, ... }:
          rec {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ self.overlays.default inputs.nvfetcher.overlays.default ];
              config.allowUnfree = true;
            };
            packages = withContents appsDir (name: pkgs.${name})
              // withContents pythonModulesDir (name: pkgs.python3Packages.${name});
            apps = mkApps pkgs (runnableApps pkgs (names appsDir));
            checks = mkCheck packages;
            devShells = withContents appsDir
              (name:
                (pkgs.${name}.overrideAttrs (old: { buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.bashInteractive ]; })))
            // withContents pythonModulesDir (name:
              (pkgs.python3Packages.${name}.overrideAttrs (old: { buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.bashInteractive ]; })))
            // {
              default = (
                inputs.nvfetcher.packages.${system}.ghcWithNvfetcher.overrideAttrs (old:
                  {
                    buildInputs = with pkgs; (old.buildInputs or [ ]) ++ [
                      bashInteractive
                      nix-index # A files database for nixpkgs
                      nix-prefetch # Prefetch checkers
                      nix-prefetch-git
                      nvfetcher # Tool of automate nix package updates
                    ];
                  }));
            };
          };
      };
}
