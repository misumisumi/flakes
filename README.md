# My nix packages and nixosModules

This repository use [nvfetcher](https://github.com/berberman/nvfetcher.git) for auto update packages.

## Usage

### Use binary cache from cachix:

```sh
$ cachix use misumisumi
```

### Run a package immediately

```sh
$ nix run github:misumisumi/flakes#<package-name>
```

### Add the overlay to your system

In your `flake.nix`

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    misumisumi = {
      url = "github:misumisumi/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, misumisumi }: {
    nixosConfigurations.my-machine = nixpkgs.lib.nixosSystem {
      # ...
      modules = [
        # ...
        {
          nixpkgs.overlays = [
            # ...
            misumisumi.overlays
          ];
        }
      ];
    };
  };
}

```

## Available packages



