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
      isRunnableApp = pkgs: name: if pkgs.${name}.passthru.runnable or false then name else null;
      runnableApps = pkgs: ts: lib.remove null (map (isRunnableApp pkgs) ts);

      pkgDir = ./packages;
      sources = import ./_sources/generated.nix;
      broken = import ./packages/broken.nix;

      ls = path: builtins.readDir path;
      isDir = ts: t: if ts.${t} == "directory" then t else null;
      names = with builtins; lib.subtractLists broken (lib.remove null (map (isDir (ls pkgDir)) (attrNames (ls pkgDir))));
      withContents = func: with builtins; listToAttrs (map (genPkg func) names);

      mkApps = pkgs: appNames: with builtins; listToAttrs (map (genApp pkgs) appNames);

      isModules = file: with lib; if (hasSuffix ".nix" file) then strings.removeSuffix ".nix" file else null;
      modules = with builtins; lib.remove null (map isModules (attrNames (ls ./modules)));
      genModule = self: name: {
        inherit name;
        value = import ./modules/${name}.nix self;
      };
      mkModules = self: with builtins; listToAttrs (map (genModule self) modules);
    in rec {
      overlay = overlays.default; # deprecated attributes for retro compatibility
      overlays.default = final: prev:
      let
        pkgSources = sources { inherit (final) fetchgit fetchurl fetchFromGitHub ; };
      in withContents (name:
        let
          pkgs = import (pkgDir + "/${name}");
          override = builtins.intersectAttrs (builtins.functionArgs pkgs) ({
            inherit name pkgSources;
            pythonPackages = final.python3.pkgs;
          });
        in final.callPackage pkgs override
        ) // { sources = pkgSources; }; } //
      flake-utils.lib.eachSystem ["x86_64-linux"] (system:
      let
        pkgs = import nixpkgs {
          system = "${system}";
          overlays = [ self.overlays.default nvfetcher.overlay];  # nvfetcherもoverlayする
          config.allowUnfree = true;
        }; in with pkgs.legacyPackages.${system}; rec {
        packages =  withContents (name: pkgs.${name});
        apps = mkApps pkgs (runnableApps pkgs names);
        checks = packages;
        devShells.default = nvfetcher.packages.${system}.ghcWithNvfetcher;  # For `nix develop`
      }) // {
        nixosModules = mkModules self;
      };
}
