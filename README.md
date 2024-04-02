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

  - @commitlint/config-angular-19.1.0
  - @commitlint/config-conventional-19.1.0
  - @commitlint/config-lerna-scopes-19.0.0
  - @commitlint/config-patternplate-19.1.0
  - @commitlint/load-19.2.0
  - @commitlint/read-19.2.1
  - @pkgdeps/update-github-actions-permissions-2.6.0
  - @pkgdeps/update-github-actions-permissions-2.6.0
  - bt-dualboot-1.0.1
  - commitlint-format-json-1.1.0
  - csharp-ls-0.11.0
  - cups-brother-hll5100dn-3.5.1-1
  - droidcam-obs-plugin-2.3.2
  - knp-bc4cef188669f88cdeb590fe7afb1021ce2ae481
  - nixos-diff
  - plemoljp-fonts-v1.7.1
  - prime-run
  - python3.11-jupynium-0.2.2
  - python3.11-pyknp-0.6.1
  - python3.11-SpeechRecognition-3.10.3
  - python3.11-suds-1.1.2
  - ricoh-sp-c260series-ppd-1.00
  - skk-emoji-jisyo-v0.0.9
  - snack-2.2.10
  - textlint-filter-rule-allowlist-4.0.0
  - textlint-filter-rule-comments-1.2.2
  - textlint-rule-preset-ja-spacing-2.3.1
  - textlint-rule-preset-ja-technical-writing-10.0.1
  - tkdnd-2.9.4
  - unityhub-latest-3.7.0
  - vrc-get-latest-v1.5.3
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-0e0fb52af809d6f675bf1ba5a828812715957762
  - zenn-cli-0.1.153

