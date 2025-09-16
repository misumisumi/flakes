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

  - @commitlint/config-angular-19.8.1
  - @commitlint/config-conventional-19.8.1
  - @commitlint/config-patternplate-19.8.1
  - @commitlint/config-workspace-scopes-19.8.1
  - @commitlint/load-19.8.1
  - @commitlint/read-19.8.1
  - @pkgdeps/update-github-actions-permissions-2.9.1
  - @pkgdeps/update-github-actions-permissions-2.9.1
  - @prettier/plugin-php-0.24.0
  - @prettier/plugin-pug-3.4.2
  - @prettier/plugin-ruby-4.0.4
  - @prettier/plugin-xml-3.4.2
  - @proofdict/textlint-rule-proofdict-3.1.2
  - bt-dualboot-1.0.1
  - commitlint-format-json-1.1.0
  - commitlint-with-plugins
  - cups-brother-hll5100dn-3.5.1-1
  - droidcam-obs-plugin-2.4.0
  - jawiki-kana-kanji-dict-2025-08-11
  - julius-speech-v4.6
  - knp-bc4cef188669f88cdeb590fe7afb1021ce2ae481
  - napi-postinstall-0.3.3
  - nixos-diff
  - openpace-1.1.3
  - ppp-scripts-2.5.2
  - prettier-plugin-go-template-0.0.15
  - prettier-plugin-kotlin-2.1.0
  - prettier-plugin-nginx-1.0.3
  - prettier-plugin-rust-0.1.9
  - prettier-plugin-sh-0.18.0
  - prettier-plugin-sql-0.19.2
  - proton-ge-rtsp-bin-GE-Proton9-22-rtsp17
  - python3.13-jupynium-0.2.6
  - python3.13-pyknp-0.6.1
  - python3.13-version-pioneer-0.0.13
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
  - virtualsmartcard-virtualsmartcard-0.10
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-2025-08-11
  - zotero-better-bibtex-7.0.50
  - zotero-night-0.4.23
  - zotero-pdf-translate-2.3.10
  - zotero-reading-list-1.5.12
  - zotero-scipdf-1.3.0
  - zotero-zotfile-5.1.2
  - zotero-zotmoov-1.2.24

