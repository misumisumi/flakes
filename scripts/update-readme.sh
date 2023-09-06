#! /usr/bin/env bash

cat <<"EOF" >README.md
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

EOF

cat <<EOF >>README.md
## Available packages

- Apps

$(nix flake show --json | jq '.packages."x86_64-linux"[].name' | sort | sed -e "s/\"//g" | grep -v python | sed -e "s/^/  - /g")

- PythonPackages

$(nix flake show --json | jq '.packages."x86_64-linux"[].name' | sort | sed -e "s/\"//g" | grep python | sed -e "s/^/  - /g")

EOF