{
  description = "Packages without nixpkgs using by Sumi-Sumi";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nvfetcher }:
    let
      lib = nixpkgs.lib;
      genPkg = func: name: {
        inherit name;
        value = func name;
      };
      genApp = pkgs: name: {
        inherit name;
        value = flake-utils.lib.mkApp { drv = pkgs.${name}; };
      };
      # For nix run
      isRunnableApp = pkgs: name: if pkgs.${name}.passthru.runnable or false then name else false;
      runnableApps = pkgs: ts: lib.remove false (map (isRunnableApp pkgs) ts);

      appsDir = ./packages/apps;
      pythonModulesDir = ./packages/python-modules;

      sources = import ./_sources/generated.nix;
      broken = import ./packages/broken.nix;

      ls = path: builtins.readDir path;
      isDir = ts: t: if ts.${t} == "directory" then t else false;
      names = targetDir: with builtins; lib.subtractLists broken (lib.remove false (map (isDir (ls targetDir)) (attrNames (ls targetDir))));
      # Make { appName = import ./<appName> }
      withContents = targetDir: func: with builtins; listToAttrs (map (genPkg func) (names targetDir));

      mkApps = pkgs: appNames: with builtins; listToAttrs (map (genApp pkgs) appNames);

      isModules = file: with lib; if (hasSuffix ".nix" file) then strings.removeSuffix ".nix" file else false;
      modules = with builtins; lib.remove false (map isModules (attrNames (ls ./modules)));
      genModule = name: {
        inherit name;
        value = import ./modules/${name}.nix;
      };
      mkModules = with builtins; listToAttrs (map genModule modules);
    in
    rec {
      overlay = overlays.default; # deprecated attributes for retro compatibility
      overlays.default = final: prev:
        let
          pkgSources = sources { inherit (final) fetchgit fetchurl fetchFromGitHub dockerTools; };
          override = name: pkg: builtins.intersectAttrs (builtins.functionArgs pkg) ({
            inherit name pkgSources;
            pythonPackages = final.python3.pkgs;
          });
        in
        withContents appsDir
          (name:
            let
              app = import (appsDir + "/${name}");
            in
            final.callPackage app (override name app)
          ) // {
          sources = pkgSources;
        } // {
          pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
            (pfinal: pprev:
              withContents pythonModulesDir (name:
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
              }; in
            self;
          python3Packages = final.python3.pkgs;
        };
    } //

    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          system = "${system}";
          overlays = [ self.overlays.default nvfetcher.overlays.default ]; # nvfetcherもoverlayする
          config.allowUnfree = true;
        }; in
      with pkgs.legacyPackages.${system}; rec {
        packages = withContents appsDir (name: pkgs.${name}) // withContents pythonModulesDir (name: pkgs.python3Packages.${name});
        apps = mkApps pkgs (runnableApps pkgs (names appsDir));
        checks = packages;
        devShells = withContents appsDir (name: pkgs.${name}) // withContents pythonModulesDir (name: pkgs.python3Packages.${name}) // { default = nvfetcher.packages.${system}.ghcWithNvfetcher; };
      }) // {
      nixosModules = mkModules;
    };
}
