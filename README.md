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

  - @commitlint/config-angular-19.5.0
  - @commitlint/config-conventional-19.5.0
  - @commitlint/config-lerna-scopes-19.5.0
  - @commitlint/config-patternplate-19.5.0
  - @commitlint/load-19.5.0
  - @commitlint/read-19.5.0
  - @pkgdeps/update-github-actions-permissions-2.6.0
  - @pkgdeps/update-github-actions-permissions-2.6.0
  - @prettier/plugin-php-0.22.2
  - @prettier/plugin-pug-3.1.0
  - @prettier/plugin-ruby-4.0.4
  - @prettier/plugin-xml-3.4.1
  - @proofdict/textlint-rule-proofdict-3.1.2
  - bt-dualboot-1.0.1
  - commitlint-format-json-1.1.0
  - commitlint-with-plugins
  - csharp-ls-0.15.0
  - cups-brother-hll5100dn-3.5.1-1
  - droidcam-obs-plugin-2.3.3
  - julius-speech-v4.6
  - knp-bc4cef188669f88cdeb590fe7afb1021ce2ae481
  - moralerspace-fonts-v1.0.2
  - moralerspace-nerd-fonts-v1.0.2
  - nixos-diff
  - plemoljp-fonts-v1.7.1
  - prettier-plugin-go-template-0.0.15
  - prettier-plugin-kotlin-2.1.0
  - prettier-plugin-nginx-1.0.3
  - prettier-plugin-rust-0.1.9
  - prettier-plugin-sh-0.14.0
  - prettier-plugin-sql-0.18.1
  - prime-run
  - python3.12-jupynium-0.2.4
  - python3.12-pyknp-0.6.1
  - ricoh-sp-c260series-ppd-1.00
  - skk-emoji-jisyo-v0.0.9
  - snack-2.2.10
  - textlint-filter-rule-allowlist-4.0.0
  - textlint-filter-rule-comments-1.2.2
  - textlint-rule-preset-ja-engineering-paper-1.0.4
  - textlint-rule-preset-ja-spacing-2.4.3
  - textlint-rule-preset-ja-technical-writing-10.0.1
  - tkdnd-2.9.4
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-49b6353c31ed2b735c9d9f22eb9469e0a3be3809
  - zenn-cli-0.1.155
  - zotero-better-bibtex-6.7.229
  - zotero-night-0.4.23
  - zotero-pdf-translate-2.0.1
  - zotero-zotfile-5.1.2

