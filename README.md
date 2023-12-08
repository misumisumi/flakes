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

- Apps

  - bt-dualboot-1.0.1
  - csharp-ls-0.10.0
  - cups-brother-hll5100dn-3.5.1-1
  - drbd9-dkms-9.1.17
  - droidcam-obs-plugin-2.1.0
  - fcitx5-nord-bdaa8fb723b8d0b22f237c9a60195c5f9c9d74d1
  - fcitx5-skk-5.1.0
  - fence-agents-4.13.1
  - knp-bc4cef188669f88cdeb590fe7afb1021ce2ae481
  - plemoljp-fonts-v1.6.0
  - prime-run
  - ricoh-sp-c260series-ppd-1.00
  - skk-emoji-jisyo-v0.0.9
  - snack-2.2.10
  - unityhub-latest-3.6.1
  - vrc-get-latest-v1.3.2
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-8688cc9ef1daa3e8d6a64bbeb2d834d09105b3d6

- PythonPackages

  - python3.11-SpeechRecognition-3.10.1
  - python3.11-doq-0.10.0
  - python3.11-pyknp-0.6.1
  - python3.11-suds-1.1.2

