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
  - csharp-ls-0.9.0
  - cups-brother-hll5100dn-3.5.1-1
  - drbd9-dkms-9.1.16
  - droidcam-obs-plugin-2.1.0
  - fcitx5-nord-bdaa8fb723b8d0b22f237c9a60195c5f9c9d74d1
  - fcitx5-skk-5.1.0
  - fence-agents-4.13.1
  - juce-7.0.8
  - knp-f98d4eefcc95309ce91e82d6ee0c6db1c3680c1a
  - plemoljp-fonts-v1.6.0
  - prime-run
  - ricoh-sp-c260series-ppd-1.00
  - skk-emoji-jisyo-v0.0.9
  - snack-2.2.10
  - udev-gothic-v1.3.1
  - unityhub-latest-3.5.2
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-3b68ce1e23a4064f0e5c6e59a2e5ff805502ba30

- PythonPackages

  - python3.10-SpeechRecognition-3.10.0
  - python3.10-doq-0.10.0
  - python3.10-pyknp-0.6.1
  - python3.10-suds-1.1.2

