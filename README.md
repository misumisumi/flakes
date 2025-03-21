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

  - @commitlint/config-angular-19.8.0
  - @commitlint/config-conventional-19.8.0
  - @commitlint/config-lerna-scopes-19.7.0
  - @commitlint/config-patternplate-19.8.0
  - @commitlint/load-19.8.0
  - @commitlint/read-19.8.0
  - @pkgdeps/update-github-actions-permissions-2.6.0
  - @pkgdeps/update-github-actions-permissions-2.6.0
  - @prettier/plugin-php-0.22.4
  - @prettier/plugin-pug-3.2.1
  - @prettier/plugin-ruby-4.0.4
  - @prettier/plugin-xml-3.4.1
  - @proofdict/textlint-rule-proofdict-3.1.2
  - bt-dualboot-1.0.1
  - commitlint-format-json-1.1.0
  - commitlint-with-plugins
  - cups-brother-hll5100dn-3.5.1-1
  - droidcam-obs-plugin-2.3.4
  - jawiki-kana-kanji-dict-2025-03-04
  - julius-speech-v4.6
  - knp-bc4cef188669f88cdeb590fe7afb1021ce2ae481
  - nixos-diff
  - openpace-1.1.3
  - prettier-plugin-go-template-0.0.15
  - prettier-plugin-kotlin-2.1.0
  - prettier-plugin-nginx-1.0.3
  - prettier-plugin-rust-0.1.9
  - prettier-plugin-sh-0.15.0
  - prettier-plugin-sql-0.18.1
  - proton-ge-rtsp-bin-GE-Proton9-22-rtsp17
  - python3.12-jupynium-0.2.6
  - python3.12-pyknp-0.6.1
  - python3.12-version-pioneer-0.0.13
  - ricoh-sp-c260series-ppd-1.00
  - skk-emoji-jisyo-v0.0.9
  - skk-emotikons-jisyo-2021-04-01
  - skk-kaomoji-jisyo-2.30.5544.102
  - snack-2.2.10
  - textlint-filter-rule-allowlist-4.0.0
  - textlint-filter-rule-comments-1.2.2
  - textlint-rule-preset-ja-engineering-paper-1.0.4
  - textlint-rule-preset-ja-spacing-2.4.3
  - textlint-rule-preset-ja-technical-writing-12.0.2
  - tkdnd-2.9.5
  - virtualsmartcard-virtualsmartcard-0.9
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-2025-03-04
  - zenn-cli-0.1.158
  - zotero-better-bibtex-7.0.5
  - zotero-night-0.4.23
  - zotero-pdf-translate-2.1.6
  - zotero-scipdf-1.3.0
  - zotero-zotfile-5.1.2
  - zotero-zotmoov-1.2.18

